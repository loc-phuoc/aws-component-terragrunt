terraform {
  source = "${dirname(find_in_parent_folders("root.hcl"))}/../terraform/ec2"
}

# Get outputs from the network module
dependency "network" {
  config_path = "../network"
  
  mock_outputs = {
    vpc_id            = "mock-vpc-id"
    private_subnet_ids = ["mock-subnet-1", "mock-subnet-2"]
    public_subnet_ids  = ["mock-subnet-3", "mock-subnet-4"]
  }
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
  vpc_id              = dependency.network.outputs.vpc_id
  subnet_ids          = dependency.network.outputs.public_subnet_ids
  ami_id              = local.env_vars.ami
  instance_type       = local.env_vars.instance_type
  instance_count      = local.env_vars.instance_count
  key_name            = local.env_vars.key_name
  enable_monitoring   = local.env_vars.enable_monitoring
}