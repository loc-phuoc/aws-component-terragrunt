locals {
  parsed = try(
    regex(".*/terragrunt/(?P<environment>[^/]+)/(?P<component>[^/]+)", get_original_terragrunt_dir()),
    {
      environment = basename(dirname(get_original_terragrunt_dir()))
      component   = "all"
    }
  )
  environment = local.parsed.environment
  component = local.parsed.component
  project_name = "astroverse"
  aws_region = "ap-southeast-1"
  
  common_tags = {
    Environment = local.environment
    Project     = local.project_name
    ManagedBy   = "Terragrunt"
  }
}

# Remote state configuration
remote_state {
  backend = "s3"
  
  config = {
    bucket         = "${local.project_name}-${local.environment}-bucket"
    key            = "${local.component}/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
    contents  = <<EOF
terraform {
  backend "s3" {
    bucket         = "${local.project_name}-${local.environment}-bucket"
    key            = "${local.component}/terraform.tfstate"
    region         = "${local.aws_region}"
    encrypt        = true
  }
}
  EOF 
  }
}

# Generate provider configuration for child modules
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  default_tags {
    tags = ${jsonencode(local.common_tags)}
  }
}
EOF
}