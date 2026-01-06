# Local values defining the discovered resources
locals {
  vpcs = {
    "kavi-vpc" = {
      id                = "vpc-04634b2ca7da026c4"
      cidr_block        = "10.0.0.0/16"
      instance_tenancy  = "default"
      enable_dns_hostnames = false
      enable_dns_support   = true
      tags = {
        Name = "kavi-vpc"
      }
    }
    "default" = {
      id                = "vpc-0dd3cf961fe2eb696"
      cidr_block        = "172.31.0.0/16"
      instance_tenancy  = "default"
      enable_dns_hostnames = true
      enable_dns_support   = true
      tags = {
        Name = "default"
      }
    }
  }

  security_groups = {
    "kavi-vpc-default" = {
      id          = "sg-01c5976c53e5ff16c"
      name        = "default"
      description = "default VPC security group"
      vpc_id      = "vpc-04634b2ca7da026c4"
      tags        = {}
    }
    "default-vpc-default" = {
      id          = "sg-0c097278164e6ed9c"
      name        = "default"
      description = "default VPC security group"
      vpc_id      = "vpc-0dd3cf961fe2eb696"
      tags = {
        Name = "Defaut"
      }
    }
  }

  subnets = {
    "kavi-new-pub" = {
      id                      = "subnet-0019e7bbb2961b32d"
      cidr_block              = "10.0.16.0/20"
      vpc_id                  = "vpc-04634b2ca7da026c4"
      availability_zone       = "ap-south-1b"
      map_public_ip_on_launch = false
      tags = {
        Name = "kavi-new-pub"
      }
    }
    "default-1a" = {
      id                      = "subnet-0c6ba19f7b0ddd345"
      cidr_block              = "172.31.32.0/20"
      vpc_id                  = "vpc-0dd3cf961fe2eb696"
      availability_zone       = "ap-south-1a"
      map_public_ip_on_launch = true
      tags = {
        Name = "default"
      }
    }
    "kavi-subnet-private1-ap-south-1a" = {
      id                      = "subnet-01a6c3e463b1639ea"
      cidr_block              = "10.0.128.0/20"
      vpc_id                  = "vpc-04634b2ca7da026c4"
      availability_zone       = "ap-south-1a"
      map_public_ip_on_launch = false
      tags = {
        Name = "kavi-subnet-private1-ap-south-1a"
      }
    }
    "kavi-subnet-public1-ap-south-1a" = {
      id                      = "subnet-0e7a851004ae0568c"
      cidr_block              = "10.0.0.0/20"
      vpc_id                  = "vpc-04634b2ca7da026c4"
      availability_zone       = "ap-south-1a"
      map_public_ip_on_launch = false
      tags = {
        Name = "kavi-subnet-public1-ap-south-1a"
      }
    }
    "default-1b" = {
      id                      = "subnet-07716162d0ecfbd4f"
      cidr_block              = "172.31.0.0/20"
      vpc_id                  = "vpc-0dd3cf961fe2eb696"
      availability_zone       = "ap-south-1b"
      map_public_ip_on_launch = true
      tags = {
        Name = "default-2"
      }
    }
    "default-1c" = {
      id                      = "subnet-0b93d479bdf3dc614"
      cidr_block              = "172.31.16.0/20"
      vpc_id                  = "vpc-0dd3cf961fe2eb696"
      availability_zone       = "ap-south-1c"
      map_public_ip_on_launch = true
      tags = {
        Name = "default-3"
      }
    }
  }
}

# VPC Resources
resource "aws_vpc" "imported" {
  for_each = local.vpcs

  cidr_block           = each.value.cidr_block
  instance_tenancy     = each.value.instance_tenancy
  enable_dns_hostnames = each.value.enable_dns_hostnames
  enable_dns_support   = each.value.enable_dns_support

  tags = each.value.tags

  lifecycle {
    # Prevent accidental deletion of imported resources
    prevent_destroy = false
  }
}

# Security Group Resources
resource "aws_security_group" "imported" {
  for_each = local.security_groups

  name        = each.value.name
  description = each.value.description
  vpc_id      = each.value.vpc_id

  # Tags only if they exist
  tags = length(each.value.tags) > 0 ? each.value.tags : null

  lifecycle {
    # Prevent accidental deletion of imported resources
    prevent_destroy = false
    # Ignore ingress/egress rules as they may be managed separately
    ignore_changes = [ingress, egress]
  }
}

# Subnet Resources
resource "aws_subnet" "imported" {
  for_each = local.subnets

  vpc_id                  = each.value.vpc_id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = each.value.tags

  lifecycle {
    # Prevent accidental deletion of imported resources
    prevent_destroy = false
  }
}