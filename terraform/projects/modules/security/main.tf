# Reusable Security Groups Module

resource "aws_security_group" "this" {
  for_each = var.security_groups

  name        = each.key
  description = each.value.description
  vpc_id      = each.value.vpc_id

  # Ingress rules will be managed separately
  dynamic "ingress" {
    for_each = each.value.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  # Egress rules will be managed separately
  dynamic "egress" {
    for_each = each.value.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = merge(var.tags, {
    Name = each.key
  })

  lifecycle {
    # Rules will need to be managed separately for existing security groups
    ignore_changes = [ingress, egress]
  }
}