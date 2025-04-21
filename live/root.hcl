#! recommended prefix: ${organization}-${application}-${environment}-${region}-${component}  eg.vl-lunch-dev-as1-ec2
#! tfstate location:   ${region}/${component}/<IaC>.tfstate                   eg./us-east-1/networking/vpc/tofu.tfstate 

locals {
  parsed = regex(".*/live/(?P<env>[^/]+)/(?P<region>[^/]+)/(?P<comp>[^/]+)", get_original_terragrunt_dir())

  global_vars  = yamldecode(file(find_in_parent_folders("global.yaml")))
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  org            = local.global_vars.org
  app            = local.global_vars.app
  account_name   = local.account_vars.locals.account_name
  account_id     = local.account_vars.locals.account_id
  default_region = local.global_vars.default_region
  aws_region     = local.parsed.region
  env            = local.parsed.env
  comp           = local.parsed.comp
  team           = local.global_vars.team
  prefix         = "${local.org}-${local.app}-${local.env}-${local.aws_region}-${local.comp}"

  common_tags = {
    Application = local.app
    Team        = local.team
    Environment = local.environment
    Project     = local.project_name
  }
}

inputs = {
  # Set commonly used inputs globally to keep child terragrunt.hcl files DRY
  aws_account_id = local.account_id
  aws_region     = local.aws_region
  env            = local.env
  comp           = local.comp
  prefix         = local.prefix
}

# Generate provider configuration for child modules
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.default_region}"
  assume_role {
    role_arn = "${local.account_vars.locals.role_arn}"
  }
  default_tags {
    tags = ${jsonencode(local.common_tags)}
  }
}
EOF
}

# Remote state configuration
remote_state {
  backend = "s3"

  config = {
    bucket  = "${local.prefix}-${local.account_name}-${local.aws_region}-terraform-state"
    key     = "${local.component}/terraform.tfstate"
    region  = local.default_region
    encrypt = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
    contents  = <<EOF
terraform {
  backend "s3" {
    bucket         = "${local.prefix}-${local.account_name}-${local.aws_region}-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.default_region}"
    encrypt        = true
  }
}
  EOF 
  }
}


