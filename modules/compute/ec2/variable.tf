variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where EC2 instances will be launched"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_count" {
  description = "Number of EC2 instances to launch"
  type        = number
  default     = 1
}

variable "key_name" {
  description = "SSH key name to use for EC2 instances"
  type        = string
}

variable "enable_monitoring" {
  description = "Enable detailed monitoring for EC2 instances"
  type        = bool
  default     = false
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = ""  # Will be dynamically determined if not specified
}

variable "whitelist_ips" {
  description = "List of IPs to whitelist for SSH access"
  type        = list(string)
  default     = [
    "27.3.88.0/24"
    ]
}