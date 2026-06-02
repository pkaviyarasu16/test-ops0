#------------------------------------------------------------------------------
# S3 Buckets - Imported from existing AWS infrastructure + security hardening
#------------------------------------------------------------------------------

data "aws_caller_identity" "current" {}

locals {
  # ops0 tracking + standard tags applied to every resource in this project
  ops0_tags = {
    "ops0:managed"        = "true"
    "ops0:conversationID" = var.conversation_id
    ManagedBy             = "ops0"
    ManagedIaC            = "terraform"
    Environment           = var.environment
    Project               = var.project_name
    Owner                 = var.owner
    CostCenter            = var.cost_center
  }

  s3_buckets = {
    "roi-vation-ops0-s3" = {
      bucket = "roi-vation-ops0-s3"
      tags = merge(
        {
          Environment = "production"
          ManagedBy   = "Terraform"
          Name        = "roi-vation-ops0-s3"
        },
        local.ops0_tags,
      )
    }
  }
}

#------------------------------------------------------------------------------
# KMS key used for S3 server-side encryption (CKV_AWS_145)
#------------------------------------------------------------------------------

resource "aws_kms_key" "s3" {
  description             = "Customer-managed KMS key for S3 bucket encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = local.ops0_tags
}

resource "aws_kms_alias" "s3" {
  name          = "alias/${var.project_name}-s3"
  target_key_id = aws_kms_key.s3.key_id
}

#------------------------------------------------------------------------------
# Primary S3 buckets (imported)
#------------------------------------------------------------------------------

resource "aws_s3_bucket" "this" {
  for_each = local.s3_buckets

  bucket = each.value.bucket

  tags = each.value.tags
}

resource "aws_s3_bucket_versioning" "this" {
  for_each = local.s3_buckets

  bucket = aws_s3_bucket.this[each.key].id

  versioning_configuration {
    status = "Enabled"
  }
}

# CKV_AWS_145: encrypt with KMS by default, enable bucket keys for cost reduction
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  for_each = local.s3_buckets

  bucket = aws_s3_bucket.this[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3.arn
    }
    bucket_key_enabled = true
  }
}

# CKV2_AWS_6: block all public access at the bucket level
resource "aws_s3_bucket_public_access_block" "this" {
  for_each = local.s3_buckets

  bucket = aws_s3_bucket.this[each.key].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CKV_AWS_18: ship S3 server access logs to a dedicated log bucket
resource "aws_s3_bucket_logging" "this" {
  for_each = local.s3_buckets

  bucket        = aws_s3_bucket.this[each.key].id
  target_bucket = aws_s3_bucket.logs.id
  target_prefix = "s3-access-logs/${each.key}/"
}

# CKV2_AWS_61: lifecycle rules - transition noncurrent versions and expire stale data
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  for_each = local.s3_buckets

  bucket = aws_s3_bucket.this[each.key].id

  rule {
    id     = "transition-and-expire-noncurrent"
    status = "Enabled"

    filter {}

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = 90
      storage_class   = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = 365
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  depends_on = [aws_s3_bucket_versioning.this]
}

# CKV2_AWS_62: emit object-created / object-removed events to an SNS topic
resource "aws_s3_bucket_notification" "this" {
  for_each = local.s3_buckets

  bucket = aws_s3_bucket.this[each.key].id

  topic {
    topic_arn = aws_sns_topic.s3_events.arn
    events = [
      "s3:ObjectCreated:*",
      "s3:ObjectRemoved:*",
    ]
  }

  depends_on = [aws_sns_topic_policy.s3_events]
}

#------------------------------------------------------------------------------
# SNS topic for S3 event notifications (CKV2_AWS_62)
#------------------------------------------------------------------------------

resource "aws_sns_topic" "s3_events" {
  name              = "${var.project_name}-s3-events"
  kms_master_key_id = aws_kms_key.s3.arn

  tags = local.ops0_tags
}

data "aws_iam_policy_document" "sns_s3_publish" {
  statement {
    sid     = "AllowS3Publish"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    resources = [aws_sns_topic.s3_events.arn]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [for k, v in aws_s3_bucket.this : v.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_sns_topic_policy" "s3_events" {
  arn    = aws_sns_topic.s3_events.arn
  policy = data.aws_iam_policy_document.sns_s3_publish.json
}

#------------------------------------------------------------------------------
# Dedicated server-access log bucket (CKV_AWS_18)
#------------------------------------------------------------------------------

resource "aws_s3_bucket" "logs" {
  bucket = "${var.project_name}-access-logs"

  tags = local.ops0_tags
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "expire-old-logs"
    status = "Enabled"

    filter {}

    expiration {
      days = 365
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  depends_on = [aws_s3_bucket_versioning.logs]
}

#------------------------------------------------------------------------------
# Cross-region replication (CKV_AWS_144)
#------------------------------------------------------------------------------

resource "aws_s3_bucket" "replica" {
  provider = aws.replica

  bucket = "${var.project_name}-replica"

  tags = local.ops0_tags
}

resource "aws_s3_bucket_public_access_block" "replica" {
  provider = aws.replica

  bucket = aws_s3_bucket.replica.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "replica" {
  provider = aws.replica

  bucket = aws_s3_bucket.replica.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "replica" {
  provider = aws.replica

  bucket = aws_s3_bucket.replica.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_iam_role" "replication" {
  name = "${var.project_name}-s3-replication"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "s3.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = local.ops0_tags
}

resource "aws_iam_role_policy" "replication" {
  name = "${var.project_name}-s3-replication"
  role = aws_iam_role.replication.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket",
        ]
        Resource = [for k, v in aws_s3_bucket.this : v.arn]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
        ]
        Resource = [for k, v in aws_s3_bucket.this : "${v.arn}/*"]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",
        ]
        Resource = "${aws_s3_bucket.replica.arn}/*"
      },
      {
        Effect   = "Allow"
        Action   = ["kms:Decrypt"]
        Resource = aws_kms_key.s3.arn
      },
    ]
  })
}

resource "aws_s3_bucket_replication_configuration" "this" {
  for_each = local.s3_buckets

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.this[each.key].id

  rule {
    id     = "replicate-all"
    status = "Enabled"

    filter {}

    delete_marker_replication {
      status = "Enabled"
    }

    destination {
      bucket        = aws_s3_bucket.replica.arn
      storage_class = "STANDARD_IA"
    }
  }

  # Both source AND destination bucket versioning must be in place before
  # PutBucketReplication will succeed. Without the explicit replica dependency
  # AWS returns: "Destination bucket must have versioning enabled."
  depends_on = [
    aws_s3_bucket_versioning.this,
    aws_s3_bucket_versioning.replica,
  ]
}
