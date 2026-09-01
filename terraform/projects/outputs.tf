#------------------------------------------------------------------------------
# Outputs
#------------------------------------------------------------------------------

output "conversation_id" {
  description = "ops0 conversation ID this project is tied to"
  value       = var.conversation_id
}

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

output "robo_don_ops0_test_bucket_id" {
  description = "ID (name) of the robo-don-ops0-test S3 bucket"
  value       = aws_s3_bucket.robo_don_ops0_test.id
}

output "robo_don_ops0_test_bucket_arn" {
  description = "ARN of the robo-don-ops0-test S3 bucket"
  value       = aws_s3_bucket.robo_don_ops0_test.arn
}
