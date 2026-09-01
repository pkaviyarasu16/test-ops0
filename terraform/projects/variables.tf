#------------------------------------------------------------------------------
# Input Variables
#------------------------------------------------------------------------------

variable "region" {
  description = "AWS region where the imported resources live"
  type        = string
  default     = "us-east-2"
}

variable "conversation_id" {
  description = "ops0 conversation ID"
  type        = string
}

variable "ec2_instances" {
  description = "Map of EC2 instances to manage, keyed by logical name"
  type = map(object({
    instance_id       = string
    instance_type     = string
    availability_zone = string
    subnet_id         = string
    tags              = map(string)
  }))
  default = {
    ops0_qa = {
      instance_id       = "i-078ce1ce32d944424"
      instance_type     = "t2.medium"
      availability_zone = "us-east-2a"
      subnet_id         = "subnet-0557dff9553ddfee3"
      tags = {
        Name = "ops0-qa"
      }
    }
  }
}
