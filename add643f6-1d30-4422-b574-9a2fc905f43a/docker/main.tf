module "s3-bucket-1" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.6.0"
}

resource "aws_s3_bucket" "aws_s3_bucket-1" {
  bucket = "jkdsjhbfqjew999j0-eops0kav"
}

