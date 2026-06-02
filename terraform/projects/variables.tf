#------------------------------------------------------------------------------
# Input Variables
#------------------------------------------------------------------------------

variable "aws_region" {
  description = "AWS region where the imported resources exist"
  type        = string
  default     = "us-east-1"
}

variable "replica_region" {
  description = "AWS region used as the cross-region replication destination for S3"
  type        = string
  default     = "us-west-2"
}

variable "conversation_id" {
  description = "ops0 conversation ID used for resource tracking and isolation"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, production)"
  type        = string
  default     = "production"
}

variable "project_name" {
  description = "Project name used for resource tagging"
  type        = string
  default     = "aws-demo-s3-bucket-roivation-demo"
}

variable "owner" {
  description = "Team or individual responsible for these resources"
  type        = string
  default     = "platform-team"
}

variable "cost_center" {
  description = "Cost center code for billing allocation"
  type        = string
  default     = ""
}
