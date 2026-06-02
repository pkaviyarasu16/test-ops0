#------------------------------------------------------------------------------
# Import blocks for existing AWS resources (Terraform 1.5+ syntax)
#------------------------------------------------------------------------------

import {
  to = aws_s3_bucket.this["roi-vation-ops0-s3"]
  id = "roi-vation-ops0-s3"
}

import {
  to = aws_s3_bucket_versioning.this["roi-vation-ops0-s3"]
  id = "roi-vation-ops0-s3"
}

import {
  to = aws_s3_bucket_server_side_encryption_configuration.this["roi-vation-ops0-s3"]
  id = "roi-vation-ops0-s3"
}
