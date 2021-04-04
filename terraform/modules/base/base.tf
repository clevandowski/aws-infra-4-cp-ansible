variable "aws_region" {
  type = string
  # default = "eu-west-3"
}

variable "egress_ip" {
  type = string
}

variable "aws_vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw"
  }
}

# Internet Gateway route, external public access
resource "aws_route_table" "public_to_igw_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.egress_ip
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public_to_igw_rt"
    Zone = "Public"
  }
}

# Create subnet in zone a 
resource "aws_subnet" "subnet_a" {
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 1)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "subnet_a"
  }
}
resource "aws_route_table_association" "subnet_a_to_igw_rta" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.public_to_igw_rt.id
}

# Create subnet in zone b 
resource "aws_subnet" "subnet_b" {
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 2)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "subnet_b"
  }
}
resource "aws_route_table_association" "subnet_b_to_igw_rta" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.public_to_igw_rt.id
}

# Create subnet in zone c 
resource "aws_subnet" "subnet_c" {
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 3)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = "${var.aws_region}c"
  tags = {
    Name = "subnet_c"
  }
}
resource "aws_route_table_association" "subnet_c_to_igw_rta" {
  subnet_id      = aws_subnet.subnet_c.id
  route_table_id = aws_route_table.public_to_igw_rt.id
}

output "vpc" {
  value = aws_vpc.vpc
}
output "public_to_igw_rt" {
  value = aws_route_table.public_to_igw_rt
}
output "subnet_a_id" {
  value = aws_subnet.subnet_a.id
}
output "subnet_b_id" {
  value = aws_subnet.subnet_b.id
}
output "subnet_c_id" {
  value = aws_subnet.subnet_c.id
}
# output "subnet_a_to_igw_rta" {
#   value = aws_route_table_association.subnet_a_to_igw_rta
# }
# output "subnet_b_to_igw_rta" {
#   value = aws_route_table_association.subnet_b_to_igw_rta
# }
# output "subnet_c_to_igw_rta" {
#   value = aws_route_table_association.subnet_c_to_igw_rta
# }
