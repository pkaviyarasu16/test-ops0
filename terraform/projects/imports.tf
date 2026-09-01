#------------------------------------------------------------------------------
# Import Blocks (Terraform 1.5+)
#
# Adopts pre-existing AWS resources into Terraform state.
#------------------------------------------------------------------------------

import {
  to = aws_instance.this["ops0_qa"]
  id = "i-078ce1ce32d944424"
}
