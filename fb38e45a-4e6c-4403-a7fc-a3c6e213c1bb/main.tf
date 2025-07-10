provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "dev_bucket" {
  bucket = var.bucket_name

  tags = {
    Environment = "dev"
    Name        = var.bucket_name
  }
}