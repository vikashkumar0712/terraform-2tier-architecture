# allocate elastic ip. this eip will be used for the nat-gateway in the public subnet pub-sub-1-a
resource "aws_eip" "eip-nat-a" {
  vpc = true

  tags = {
    Name = "eip-nat-a"
  }
}
# allocate elastic ip. this eip will be used for the nat-gateway in the public subnet pub-sub-2-b
resource "aws_eip" "eip-nat-b" {
  vpc = true

  tags = {
    Name = "eip-nat-b"
  }
}

# Create a nat gateway in public subnet pub-sub-1-a
resource "aws_nat_gateway" "nat-a" {
  allocation_id = aws_eip.eip-nat-a.id
  subnet_id = var.pub_sub_1a.id
  tags = {
    Name = "nat-a"
  }
  # to ensure proper ordering, it is recommended to add an explicit dependency
  depends_on = [var.igw_id]

}

resource "aws_nat_gateway" "nat-b" {
  allocation_id = aws_eip.eip-nat-b.id
  subnet_id     = var.pub_sub_2b_id

  tags   = {
    Name = "nat-b"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  # on the internet gateway for the vpc.
  depends_on = [var.igw_id]
}

# First Private Route table to create the flow from first nat gateway to 2 private subnets
resource "aws_route_table" "pri-rt-a" {
  vpc_id            = var.vpc_id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat-a.id
  }

  tags   = {
    Name = "Pri-rt-a"
  }
}

# associate private subnet pri-sub-3-a with private route table Pri-RT-A
resource "aws_route_table_association" "pri-sub-3a-with-Pri-rt-a" {
  subnet_id         = var.pri_sub_3a_id
  route_table_id    = aws_route_table.pri-rt-a.id
}

# associate private subnet pri-sub-4b with private route table Pri-rt-b
resource "aws_route_table_association" "pri-sub-4b-with-Pri-rt-a" {
  subnet_id         = var.pri_sub_4b_id
  route_table_id    = aws_route_table.pri-rt-a.id
}

# Second Private Route table to create the flow from second nat gateway to another 2 private subnets
resource "aws_route_table" "pri-rt-b" {
  vpc_id            = var.vpc_id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat-b.id
  }

  tags   = {
    Name = "Pri-rt-b"
  }
}

# associate private subnet pri-sub-3-a with private route table Pri-RT-A
resource "aws_route_table_association" "pri-sub-5a-with-Pri-rt-b" {
  subnet_id         = var.pri_sub_5a_id
  route_table_id    = aws_route_table.pri-rt-b.id
}

# associate private subnet pri-sub-4b with private route table Pri-rt-b
resource "aws_route_table_association" "pri-sub-4b-with-Pri-rt-b" {
  subnet_id         = var.pri_sub_6b_id
  route_table_id    = aws_route_table.pri-rt-b.id
}