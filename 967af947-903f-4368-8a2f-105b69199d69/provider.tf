provider "aws" {
  region = var.region

  default_tags {
    tags = {
      "Environment" = var.environment
      "ManagedBy"   = "OpenTofu"
      "Project"     = var.project_name
    }
  }
}

