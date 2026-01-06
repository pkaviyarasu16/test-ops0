# Imported AWS Infrastructure

This Terraform configuration manages existing AWS infrastructure that has been imported into Terraform state.

## Resources Managed

- **VPCs**: 2 VPCs (kavi-vpc, default)
- **Security Groups**: 2 default security groups
- **Subnets**: 6 subnets across availability zones

## Import Process

To import these resources into Terraform state:

```bash
# Initialize Terraform
terraform init

# Generate import plan
terraform plan -generate-config-out=generated.tf

# Apply the import (Terraform 1.5+)
terraform apply
```

With Terraform 1.5+, the import blocks in `imports.tf` will automatically import the resources when you run `terraform apply`.

## Resource Structure

### VPCs
- **kavi-vpc** (vpc-04634b2ca7da026c4): 10.0.0.0/16
- **default** (vpc-0dd3cf961fe2eb696): 172.31.0.0/16

### Security Groups
- **kavi-vpc-default** (sg-01c5976c53e5ff16c): Default security group for kavi-vpc
- **default-vpc-default** (sg-0c097278164e6ed9c): Default security group for default VPC

### Subnets
- **kavi-new-pub**: 10.0.16.0/20 in ap-south-1b
- **kavi-subnet-public1-ap-south-1a**: 10.0.0.0/20 in ap-south-1a
- **kavi-subnet-private1-ap-south-1a**: 10.0.128.0/20 in ap-south-1a
- **default-1a**: 172.31.32.0/20 in ap-south-1a
- **default-1b**: 172.31.0.0/20 in ap-south-1b
- **default-1c**: 172.31.16.0/20 in ap-south-1c

## Important Notes

1. **Tags**: Resource tags match exactly what exists in AWS - no additional tags have been added
2. **Security Group Rules**: Ingress and egress rules are ignored in lifecycle to prevent drift
3. **Default VPCs**: The default VPC and its resources are included and managed
4. **Prevent Destroy**: Set to false for flexibility, but be cautious when destroying resources

## Usage

```bash
# View planned changes
terraform plan

# Apply configuration
terraform apply

# View outputs
terraform output
```

## Outputs

The configuration provides outputs for:
- VPC IDs and CIDR blocks
- Security group IDs and names
- Subnet IDs, CIDR blocks, and availability zones
- Summary count of imported resources