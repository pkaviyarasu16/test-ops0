provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "bucket" {
  bucket = "kavinqnweifnqwebf-kjqbdkw-kavi"
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "narmatha_bucket" {
  bucket = "narmathaqpksdmoj-qzdwe"
}

resource "aws_s3_bucket_ownership_controls" "narmatha_bucket_ownership" {
  bucket = aws_s3_bucket.narmatha_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "narmatha_public_access_block" {
  bucket                  = aws_s3_bucket.narmatha_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}