terraform {
  backend "s3" {
    bucket  = "roi-vation-ops0-s3"
    key     = "discovery/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    # NOTE: native S3 state locking via `use_lockfile` requires Terraform >= 1.10.
    # This project pins `required_version = ">= 1.5.0"`, so locking is not configured
    # at the backend level. Add a `dynamodb_table = "..."` here once a lock table
    # exists, or bump `required_version` to >= 1.10 and re-add `use_lockfile = true`.
  }
}
