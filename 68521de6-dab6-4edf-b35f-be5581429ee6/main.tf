terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "random_pet" "bucket_name" {
  length    = 2
  separator = "-"
  prefix    = var.bucket_prefix
}

resource "aws_s3_bucket" "random_bucket" {
  bucket = random_pet.bucket_name.id

  tags = {
    Name        = "Random Named Bucket"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.random_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.random_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}