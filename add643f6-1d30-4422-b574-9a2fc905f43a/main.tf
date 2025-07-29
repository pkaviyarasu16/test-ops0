provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "data_bucket" {
  bucket = "datatatattatata-tatata"
}