module "vpc-1" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "5.19.0"
  cidr            = "10.0.0.0/16"
  public_subnets  = ["10.0.2.0/24"]
  private_subnets = ["10.0.1.0/24"]
  azs             = [""]
}

