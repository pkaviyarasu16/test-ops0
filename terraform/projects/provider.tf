#------------------------------------------------------------------------------
# AWS Provider Configuration
#------------------------------------------------------------------------------

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Secondary provider used as the cross-region replication destination (CKV_AWS_144)
provider "aws" {
  alias  = "replica"
  region = var.replica_region
}
