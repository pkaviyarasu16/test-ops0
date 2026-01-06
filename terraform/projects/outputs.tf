# VPC Outputs
output "vpc_ids" {
  description = "Map of VPC names to their IDs"
  value = {
    for k, v in aws_vpc.imported : k => v.id
  }
}

output "vpc_cidr_blocks" {
  description = "Map of VPC names to their CIDR blocks"
  value = {
    for k, v in aws_vpc.imported : k => v.cidr_block
  }
}

# Security Group Outputs
output "security_group_ids" {
  description = "Map of security group keys to their IDs"
  value = {
    for k, v in aws_security_group.imported : k => v.id
  }
}

output "security_group_names" {
  description = "Map of security group keys to their names"
  value = {
    for k, v in aws_security_group.imported : k => v.name
  }
}

# Subnet Outputs
output "subnet_ids" {
  description = "Map of subnet keys to their IDs"
  value = {
    for k, v in aws_subnet.imported : k => v.id
  }
}

output "subnet_cidr_blocks" {
  description = "Map of subnet keys to their CIDR blocks"
  value = {
    for k, v in aws_subnet.imported : k => v.cidr_block
  }
}

output "subnet_availability_zones" {
  description = "Map of subnet keys to their availability zones"
  value = {
    for k, v in aws_subnet.imported : k => v.availability_zone
  }
}

# Summary Output
output "import_summary" {
  description = "Summary of imported resources"
  value = {
    vpcs            = length(aws_vpc.imported)
    security_groups = length(aws_security_group.imported)
    subnets         = length(aws_subnet.imported)
  }
}