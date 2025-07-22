provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "bucket" {
  bucket = "iqnhweirx283n4982x-x123n2kka"
}