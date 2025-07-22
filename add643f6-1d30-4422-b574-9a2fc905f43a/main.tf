provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "bucket" {
  bucket = "neeteshis7ahero0000-923j2d38"
}