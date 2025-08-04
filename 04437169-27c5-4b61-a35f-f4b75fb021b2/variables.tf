variable "region" {
  description = "The AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "jinininndkwbef-qerferf"
}

variable "bucket_name_2" {
  description = "The name of the second S3 bucket"
  type        = string
  default     = "jinininndkwbef-qerferf-2"
}