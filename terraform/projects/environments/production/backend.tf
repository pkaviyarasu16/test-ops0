terraform {
  backend "s3" {
    bucket = "34234dd2ddfsf3f34"
    key    = "discovery/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
