# VPC Creation
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Internet Gateway to attach with VPC

resource "aws_internet_gateway" "internet_gateway" {        
    vpc_id = aws_vpc.vpc.id
    tags = {
      Name = "${var.project_name}-ig"
    }  
}

data "aws_availability_zone" "available_zones" {
  
}

resource "aws_subnet" "pub_sub_1a" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.pub_sub_1a_cidr
  availability_zone = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "Pub_subnet_1a"
  }
}

resource "aws_subnet" "pub_sub_2b" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.pub_sub_2b_cidr
  availability_zone = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "Pub_subnet_2b"
  }
}

# Route table and public route
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id 
  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "Public-rt"
  }
}
# Route table association with public subnets
resource "aws_route_table_association" "pub-sub-1a_route_table_association" {

    subnet_id = aws_subnet.pub_sub_1a.id
    route_table_id = aws_route_table.route_table.id
  
}

resource "aws_route_table_association" "pub-sub-2b_route_table_association" {

    subnet_id = aws_subnet.pub_sub_2b.id
    route_table_id = aws_route_table.route_table.id
  
}

resource "aws_subnet" "pri_sub_3a" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.pri_sub_3a_cidr
    availability_zone = data.aws_availability_zone.available_zones.names[0]

    tags = {
        Name = "Private_subnet_3a"
    }
  
}
resource "aws_subnet" "pri_sub_4b" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.pri_sub_4b_cidr
    availability_zone = data.aws_availability_zones.available_zones.names[1]
    map_public_ip_on_launch = false

    tags = {
        Name = "Private_subnet_4b"
    }
  
}

resource "aws_subnet" "pri_sub_5a" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.pri_sub_5a_cidr
    availability_zone = data.aws_availability_zones.available_zones.names[0]
    map_public_ip_on_launch = false

    tags = {
        Name = "Private_subnet_5a"
    }
  
}

resource "aws_subnet" "pri_sub_6b" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.pri_sub_6b_cidr
    availability_zone = data.aws_availability_zones.available_zones.names[0]
    map_public_ip_on_launch = false

    tags = {
        Name = "Private_subnet_6b"
    }
  
}