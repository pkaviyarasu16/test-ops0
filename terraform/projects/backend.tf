terraform {
  backend "s3" {
    bucket         = "roi-vation-ops0-s3"
    key            = "discovery/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true
  }
}
