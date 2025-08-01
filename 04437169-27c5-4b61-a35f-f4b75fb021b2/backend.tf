terraform {
  backend "s3" {
    bucket  = "opszero-948f5702-7ac4-4a49-9ba5-46607f46df67"
    key     = "948f5702-7ac4-4a49-9ba5-46607f46df67/04437169-27c5-4b61-a35f-f4b75fb021b2/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}