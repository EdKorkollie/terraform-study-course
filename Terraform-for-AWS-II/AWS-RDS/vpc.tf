#create AWS VPC
resource "aws_vpc" "levelup_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  /*
instance tenancy means once we are goint to create the EC2 instance, the instance is going to use that particular network
if it will keep the instance tenancy default, then more than one instance can be sped up on the same hardware.
if you will change the instance tenancy, then each and every instance which you are going to spin up will be be on a separate hardwere which will cost you alot.
*/
  tags = {
    Name = "levelup_vpc"
  }
}

# Subnet in custom VPC 1a
resource "aws_subnet" "levelupvpc-public-1" {
  vpc_id                  = aws_vpc.levelup_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "levelupvpc-public--1"
  }
}

# Subnet in custom VPC 1b
resource "aws_subnet" "levelupvpc-public-2" {
  vpc_id                  = aws_vpc.levelup_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"

  tags = {
    Name = "levelupvpc-public-2"
  }
}

# Subnet in custom VPC 1c
resource "aws_subnet" "levelupvpc-public-3" {
  vpc_id                  = aws_vpc.levelup_vpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1c"

  tags = {
    Name = "levelupvpc-public-3"
  }
}

# Private Subnet in custom VPC 1a
resource "aws_subnet" "levelupvpc-private-1" {
  vpc_id                  = aws_vpc.levelup_vpc.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"

  tags = {
    Name = "levelupvpc-private-1"
  }
}

# Private Subnet in custom VPC 1b
resource "aws_subnet" "levelupvpc-private-2" {
  vpc_id                  = aws_vpc.levelup_vpc.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"

  tags = {
    Name = "levelupvpc-private-2"
  }
}

# Private Subnet in custom VPC 1c
resource "aws_subnet" "levelupvpc-private-3" {
  vpc_id                  = aws_vpc.levelup_vpc.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1c"

  tags = {
    Name = "levelupvpc-private-3"
  }
}

#custom internet Gateway
resource "aws_internet_gateway" "levelup-gw" {
  vpc_id = aws_vpc.levelup_vpc.id

  tags = {
    Name = "levelup-gw"
  }
}

#routing table for the custom vpc
resource "aws_route_table" "levelup-public-rt" {
  vpc_id = aws_vpc.levelup_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.levelup-gw.id
  }

  tags = {
    Name = "levelup-public-rt"
  }
}

#Route table association
resource "aws_route_table_association" "levelup-public-1-a" {
  subnet_id      = aws_subnet.levelupvpc-public-1.id
  route_table_id = aws_route_table.levelup-public-rt.id
}

#Route table association
resource "aws_route_table_association" "levelup-public-1-b" {
  subnet_id      = aws_subnet.levelupvpc-public-2.id
  route_table_id = aws_route_table.levelup-public-rt.id
}

#Route table association
resource "aws_route_table_association" "levelup-public-1-c" {
  subnet_id      = aws_subnet.levelupvpc-public-3.id
  route_table_id = aws_route_table.levelup-public-rt.id
}


