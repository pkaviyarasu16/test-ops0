provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "bucket" {
  bucket = "newops02930u1293jro3j-wer134"
}