#------------------------------------------------------------------------------
# S3 Bucket: robo-don-ops0-test
#------------------------------------------------------------------------------

resource "aws_s3_bucket" "robo_don_ops0_test" {
  bucket = "robo-don-ops0-test"

  tags = {
    Name = "robo-don-ops0-test"
  }
}

resource "aws_s3_bucket_versioning" "robo_don_ops0_test" {
  bucket = aws_s3_bucket.robo_don_ops0_test.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "robo_don_ops0_test" {
  bucket = aws_s3_bucket.robo_don_ops0_test.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "robo_don_ops0_test" {
  bucket = aws_s3_bucket.robo_don_ops0_test.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
