provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "dhaidhadha-jansdjmehi-kavi"
}