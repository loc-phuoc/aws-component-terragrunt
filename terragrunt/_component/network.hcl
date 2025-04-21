terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../terraform/network"
}

locals {
  root_locals = read_terragrunt_config(find_in_parent_folders("root.hcl")).locals
  environment = local.root_locals.environment
  component   = local.root_locals.component

  env_config = yamldecode(file(find_in_parent_folders("_env/${local.environment}_config.yaml")))
  
  env_vars = local.env_config[local.component]
}

inputs = {
  project_name           = local.root_locals.project_name
  environment            = local.root_locals.environment
  vpc_cidr               = local.env_vars.vpc_cidr
  public_subnet_cidrs    = local.env_vars.public_subnet_cidrs
  private_subnet_cidrs   = local.env_vars.private_subnet_cidrs
  availability_zones     = local.env_vars.availability_zones
  enable_nat_gateway     = local.env_vars.enable_nat_gateway
}