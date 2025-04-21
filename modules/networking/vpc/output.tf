output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "The ID of the VPC"
}

output "private_subnet_ids" {
  value       = aws_subnet.private_subnet[*].id
  description = "List of private subnet IDs"
}

output "public_subnet_ids" {
  value       = aws_subnet.public_subnet[*].id
  description = "List of public subnet IDs"
}