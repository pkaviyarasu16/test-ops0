# Import blocks for VPCs
import {
  to = aws_vpc.imported["kavi-vpc"]
  id = "vpc-04634b2ca7da026c4"
}

import {
  to = aws_vpc.imported["default"]
  id = "vpc-0dd3cf961fe2eb696"
}

# Import blocks for Security Groups
import {
  to = aws_security_group.imported["kavi-vpc-default"]
  id = "sg-01c5976c53e5ff16c"
}

import {
  to = aws_security_group.imported["default-vpc-default"]
  id = "sg-0c097278164e6ed9c"
}

# Import blocks for Subnets
import {
  to = aws_subnet.imported["kavi-new-pub"]
  id = "subnet-0019e7bbb2961b32d"
}

import {
  to = aws_subnet.imported["default-1a"]
  id = "subnet-0c6ba19f7b0ddd345"
}

import {
  to = aws_subnet.imported["kavi-subnet-private1-ap-south-1a"]
  id = "subnet-01a6c3e463b1639ea"
}

import {
  to = aws_subnet.imported["kavi-subnet-public1-ap-south-1a"]
  id = "subnet-0e7a851004ae0568c"
}

import {
  to = aws_subnet.imported["default-1b"]
  id = "subnet-07716162d0ecfbd4f"
}

import {
  to = aws_subnet.imported["default-1c"]
  id = "subnet-0b93d479bdf3dc614"
}