# AWS Infrastructure with Terraform and Terragrunt

This repository provides a structured approach to managing AWS infrastructure using Terraform with Terragrunt as the orchestration layer. It implements infrastructure-as-code best practices with environment separation and component modularity.

## Repository Structure

```
.
├── terraform
│   ├── ec2
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variable.tf
│   └── network
└── terragrunt
    ├── _component
    │   ├── ec2.hcl
    │   └── network.hcl
    ├── _env
    │   ├── dev_config.yaml
    │   └── prod_config.yaml
    ├── dev
    │   ├── ec2
    │   │   └── terragrunt.hcl
    │   ├── network
    │   │   └── terragrunt.hcl
    │   └── .terraform-version
    ├── prod
    └── root.hcl
```

## Features

- **Environment Separation**: Easily manage different environments (dev, prod) with isolated state files
- **Component Modularity**: Each infrastructure component (EC2, network) is defined as a reusable module
- **Configuration Inheritance**: DRY configurations with Terragrunt's include pattern
- **Remote State Management**: Automated S3 backend configuration
- **Environment-Specific Variables**: YAML configuration files for each environment
- **Dependency Management**: Handle dependencies between components (EC2 depends on network)

## Components

### Network Module

- VPC creation
- Public and private subnets
- Internet Gateway
- NAT Gateway (conditionally deployed)
- Route tables

### EC2 Module

- Instance deployment
- Security group configuration
- Elastic IP assignment
- Customizable instance types and counts per environment

## Prerequisites

- Terraform
- Terragrunt
- AWS CLI configured with appropriate credentials

## Usage

### Initializing and Planning

```bash
# plan
terragrunt plan run-all
# working-dir
terragrunt run-all --working-dir <working_dir> plan
```

### Applying Changes

```bash
# Apply changes for all components in an environment
terragrunt run-all --working-dir <working_dir> apply
```

### Destroying Resources

```bash
# Destroy all resources in an environment
terragrunt run-all --working-dir <working_dir> destroy
```

## Configuration Customization

Environment-specific configurations are stored in YAML files:
- dev_config.yaml - Development environment
- prod_config.yaml - Production environment

Modify these files to customize the infrastructure for each environment.

## Adding New Components

1. Create a Terraform module in the `terraform` directory
2. Add a component configuration in `_component/`
3. Create component configuration files in each environment directory