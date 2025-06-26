variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "bucket_prefix" {
  description = "Prefix for the randomly generated bucket name"
  type        = string
  default     = "tf-bucket"
}

variable "environment" {
  description = "Environment tag for the bucket"
  type        = string
  default     = "dev"
}