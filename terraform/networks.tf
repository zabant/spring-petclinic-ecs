# Main VPC for spring-petclinic

resource "aws_vpc" "spring_petclinic_vpc" {
  provider             = aws.region-master
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "spring-petclinic-vpc"
  }
}





# VPC Endpoints

#resource "aws_vpc_endpoint" "ecr_dkr" {
#  vpc_id              = aws_vpc.spring_petclinic_vpc.id
#  private_dns_enabled = true
#  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
#  vpc_endpoint_type   = "Interface"
#  security_group_ids  = [aws_security_group.vpce.id]
#  subnet_ids          = [aws_subnet.private.id]
#
#  tags = {
#    Name = "vpce-dkr"
#  }
#}

#resource "aws_vpc_endpoint" "ecr_api" {
#  vpc_id              = aws_vpc.spring_petclinic_vpc.id
#  private_dns_enabled = true
#  service_name        = "com.amazonaws.${var.region}.ecr.api"
#  vpc_endpoint_type   = "Interface"
#  security_group_ids  = [aws_security_group.vpce.id]
#  subnet_ids          = [aws_subnet.private.id]
#
#  tags = {
#    Name = "vpce-api"
#  }
#}

#resource "aws_vpc_endpoint" "s3" {
#  vpc_id          = aws_vpc.spring_petclinic_vpc.id
#  service_name    = "com.amazonaws.${var.region}.s3"
#  route_table_ids = [aws_route_table.private.id]
#
#  tags = {
#    Name = "vpce-s3"
#  }
#}





# IGW 

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.spring_petclinic_vpc.id
  tags = {
    Name = "spring-petclinic-igw"
  }
}





# NAT Gateway

resource "aws_nat_gateway" "private_nat" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.private.id
}






# Data what get list of AZs

data "aws_availability_zones" "azs" {
  provider = aws.region-master
  state    = "available"
}






# Subnets

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.spring_petclinic_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = element(data.aws_availability_zones.azs.names, 0)

  tags = {
    Name = "spring-petclinic-private-subnet"
  }
}

resource "aws_subnet" "public" {
  provider                = aws.region-master
  vpc_id                  = aws_vpc.spring_petclinic_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = element(data.aws_availability_zones.azs.names, 1)
  map_public_ip_on_launch = true

  tags = {
    Name = "spring-petclinic-public-subnet"
  }
}






# Public subnet Route Table

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.spring_petclinic_vpc.id

  tags = {
    Name = "spring-petclinic-route-table"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}







# Private subnet Route Table

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.spring_petclinic_vpc.id

  tags = {
    Name = "spring-petclinic-private-route-table"
  }
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = aws_subnet.private.cidr_block
  nat_gateway_id         = aws_nat_gateway.private_nat.id
}

resource "aws_route_table_association" "private_rta" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
