#------------------------------------------------------------------------------
# Outputs
#------------------------------------------------------------------------------

output "instance_ids" {
  description = "Map of logical name to EC2 instance ID"
  value       = { for k, v in aws_instance.this : k => v.id }
}

output "instance_arns" {
  description = "Map of logical name to EC2 instance ARN"
  value       = { for k, v in aws_instance.this : k => v.arn }
}

output "instance_private_ips" {
  description = "Map of logical name to private IP"
  value       = { for k, v in aws_instance.this : k => v.private_ip }
}

output "instance_public_ips" {
  description = "Map of logical name to public IP"
  value       = { for k, v in aws_instance.this : k => v.public_ip }
}
