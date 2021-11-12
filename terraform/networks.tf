resource "aws_vpc" "spring_petclinic_vpc" {
  provider             = aws.region-master
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "spring-petclinic-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.spring_petclinic_vpc.id
  tags = {
    Name = "spring-petclinic-igw"
  }
}

data "aws_availability_zones" "azs" {
  provider = aws.region-master
  state    = "available"
}

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

resource "aws_subnet" "public2" {
  provider                = aws.region-master
  vpc_id                  = aws_vpc.spring_petclinic_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = element(data.aws_availability_zones.azs.names, 2)
  map_public_ip_on_launch = true

  tags = {
    Name = "spring-petclinic-public-subnet"
  }
}

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

