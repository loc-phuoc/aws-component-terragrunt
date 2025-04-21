output "instance_ids" {
  value       = aws_instance.vps[*].id
  description = "The IDs of the EC2 instances"
}

output "instance_public_ips" {
  value       = aws_eip.eip[*].public_ip
  description = "The public IPs of the EC2 instances"
}

output "instance_private_ips" {
  value       = aws_instance.vps[*].private_ip
  description = "The private IPs of the EC2 instances"
}

output "security_group_id" {
  value       = aws_security_group.instance_sg.id
  description = "The ID of the security group"
}