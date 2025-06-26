provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "bucket" {
  bucket = "opiehf091234-348rh1if"
}