#Create VPC
resource "aws_vpc" "spring_petclinic_vpc" {
  provider             = aws.region-master
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "spring_petclinic_vpc"
  }
}

#Create IGW
resource "aws_internet_gateway" "igw" {
  provider = aws.region-master
  vpc_id   = aws_vpc.spring_petclinic_vpc.id
}

#Get all available AZ in VPC
data "aws_availability_zones" "azs" {
  provider = aws.region-master
  state    = "available"
}

#Create subnet #1
resource "aws_subnet" "private" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.spring_petclinic_vpc.id
  cidr_block        = "10.0.1.0/24"
}

#Create subnet #2
resource "aws_subnet" "public" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id            = aws_vpc.spring_petclinic_vpc.id
  cidr_block        = "10.0.2.0/24"
}
