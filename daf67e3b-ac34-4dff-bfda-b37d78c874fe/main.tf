provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "bucket" {
  bucket = "rockerskiwiiwiwiiw-tribe-tribal-01"
}