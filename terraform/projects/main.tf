#------------------------------------------------------------------------------
# EC2 Instances (imported from existing AWS infrastructure)
#------------------------------------------------------------------------------

resource "aws_instance" "this" {
  for_each = var.ec2_instances

  ami               = each.value.ami
  instance_type     = each.value.instance_type
  availability_zone = each.value.availability_zone
  subnet_id         = each.value.subnet_id

  tags = each.value.tags

  lifecycle {
    ignore_changes = [
      ami,
      user_data,
      user_data_base64,
      ephemeral_block_device,
      root_block_device,
      ebs_block_device,
      network_interface,
    ]
  }
}
