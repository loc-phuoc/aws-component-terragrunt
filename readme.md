# AWS Infrastructure with Terraform and Terragrunt

This repository provides a structured approach to managing AWS infrastructure using Terraform with Terragrunt as the orchestration layer. It implements infrastructure-as-code best practices with environment separation and component modularity.

## Repository Structure

```
.
├── terraform/                  # Terraform modules for AWS components
│   ├── apigateway/             # API Gateway resources
│   ├── cloudformation/         # CloudFormation templates
│   ├── cloudfront/             # Content delivery network
│   ├── cloudtrail/             # AWS API activity tracking
│   ├── cloudwatch/             # Monitoring and logging
│   ├── codepipeline/           # CI/CD pipeline
│   ├── dynamodb/               # NoSQL database
│   ├── ec2/                    # EC2 instances
│   ├── ecr/                    # Elastic Container Registry
│   ├── ecs/                    # Elastic Container Service
│   ├── eks/                    # Kubernetes service
│   ├── elasticache/            # In-memory caching
│   ├── elb/                    # Load balancing
│   ├── eventbridge/            # Event bus service
│   ├── ga/                     # Global Accelerator
│   ├── iam/                    # Identity and Access Management
│   ├── lambda/                 # Serverless functions
│   ├── network/                # VPC and networking
│   ├── r53/                    # Route 53 DNS
│   ├── rds/                    # Relational Database Service
│   ├── s3/                     # Object storage
│   ├── ses/                    # Simple Email Service
│   ├── sns/                    # Notification service
│   ├── sqs/                    # Message queuing
│   ├── ssm/                    # Systems Manager
│   └── waf/                    # Web Application Firewall
└── terragrunt/                 # Terragrunt configuration
    ├── _component/             # Component-specific configurations
    │   ├── ec2.hcl             # EC2 component configuration
    │   └── network.hcl         # Network component configuration
    ├── _env/                   # Environment-specific variables
    │   ├── dev_config.yaml     # Development environment config
    │   └── prod_config.yaml    # Production environment config
    ├── dev/                    # Development environment
    │   ├── ec2/                # EC2 component in dev
    │   │   └── terragrunt.hcl
    │   ├── network/            # Network component in dev
    │   │   └── terragrunt.hcl
    │   └── .terraform-version
    ├── prod/                   # Production environment
    │   ├── ec2/                # EC2 component in prod
    │   │   └── terragrunt.hcl
    │   ├── network/            # Network component in prod
    │   │   └── terragrunt.hcl
    │   └── .terraform-version
    └── root.hcl                # Root Terragrunt configuration
```

## Features

- **Environment Separation**: Easily manage different environments (dev, prod) with isolated state files
- **Component Modularity**: Each infrastructure component (EC2, network) is defined as a reusable module
- **Configuration Inheritance**: DRY configurations with Terragrunt's include pattern
- **Remote State Management**: Automated S3 backend configuration
- **Environment-Specific Variables**: YAML configuration files for each environment
- **Dependency Management**: Handle dependencies between components (EC2 depends on network)
- **Comprehensive AWS Coverage**: Structure for provisioning all major AWS services

## Components

Implemented Components

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

Available AWS Service Modules (Structure Ready)

This repository includes module structure for all major AWS services:

- **Compute**: EC2, Lambda, ECS, EKS, ECR
- **Storage**: S3, EBS (via EC2)
- **Database**: RDS, DynamoDB, ElastiCache
- **Networking**: VPC, Route 53, ELB, Global Accelerator
- **Security**: IAM, WAF, CloudTrail
- **Integration**: EventBridge, SNS, SQS, SES
- **Monitoring**: CloudWatch, SSM
- **Application Services**: API Gateway, CloudFront
- **Developer Tools**: CodePipeline, CloudFormation

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