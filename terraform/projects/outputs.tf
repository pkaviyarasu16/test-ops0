#------------------------------------------------------------------------------
# Outputs
#------------------------------------------------------------------------------

output "s3_bucket_ids" {
  description = "Map of imported S3 bucket IDs keyed by logical name"
  value       = { for k, v in aws_s3_bucket.this : k => v.id }
}

output "s3_bucket_arns" {
  description = "Map of imported S3 bucket ARNs keyed by logical name"
  value       = { for k, v in aws_s3_bucket.this : k => v.arn }
}

output "s3_bucket_domain_names" {
  description = "Map of imported S3 bucket domain names keyed by logical name"
  value       = { for k, v in aws_s3_bucket.this : k => v.bucket_domain_name }
}

output "s3_bucket_regional_domain_names" {
  description = "Map of imported S3 bucket regional domain names keyed by logical name"
  value       = { for k, v in aws_s3_bucket.this : k => v.bucket_regional_domain_name }
}

output "s3_logs_bucket_id" {
  description = "ID of the dedicated S3 server-access log bucket"
  value       = aws_s3_bucket.logs.id
}

output "s3_replica_bucket_arn" {
  description = "ARN of the cross-region replication destination bucket"
  value       = aws_s3_bucket.replica.arn
}

output "s3_kms_key_arn" {
  description = "ARN of the customer-managed KMS key used for S3 encryption"
  value       = aws_kms_key.s3.arn
}

output "s3_events_topic_arn" {
  description = "ARN of the SNS topic receiving S3 object event notifications"
  value       = aws_sns_topic.s3_events.arn
}
