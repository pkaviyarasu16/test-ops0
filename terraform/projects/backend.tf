terraform {
  backend "s3" {
    bucket         = "efrfefwefwef-24567"
    key            = "discovery/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true
  }
}
