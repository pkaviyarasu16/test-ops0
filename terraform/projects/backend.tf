terraform {
  backend "s3" {
    bucket         = "random011bucktest"
    key            = "discovery/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
