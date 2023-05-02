# This is to create relevant resources under VPC
#
#  1. VPC
#  2. Subnets
#  3. Internet Gateway (IGW)
#  4. NAT Gateway (NAT)
#  5. Route Tables (RTs)
#  6. EIP

## Get availability zones
data "aws_availability_zones" "available" {}

#####################
####   1. VPC    ####
#####################

resource "aws_vpc" "my_simple_vpc" {
  cidr_block = "10.2.0.0/16"

  tags = {
    Name = "${var.resource_prefix}-my-vpc",
  }
}

#####################
#### 2. Subnets  ####
#####################

resource "aws_subnet" "public" {
  count                   = 1
  vpc_id                  = aws_vpc.my_simple_vpc.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.2.1${count.index}.0/24"
  map_public_ip_on_launch = true

  tags = tomap({
    Name = "${var.resource_prefix}-public-subnet${count.index + 1}",
  })
}


resource "aws_subnet" "private" {
  count                   = 1
  vpc_id                  = aws_vpc.my_simple_vpc.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.2.2${count.index}.0/24"
  map_public_ip_on_launch = false

  tags = tomap({
    Name = "${var.resource_prefix}-private-subnet${count.index + 1}",
  })
}

#####################
####    3. IGW   ####
#####################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_simple_vpc.id

  tags = {
    Name = "${var.resource_prefix}-igw"
  }
}

#####################
####    4. NAT   ####
#####################

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = element(aws_subnet.public.*.id, 0)
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.resource_prefix}-nat-gw"
  }
}

#####################
####    5. RTs   ####
#####################

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.my_simple_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.resource_prefix}-public-route"
  }
}

resource "aws_route_table_association" "public_route" {
  count          = 1
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.my_simple_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "${var.resource_prefix}-private-route",
  }
}

resource "aws_route_table_association" "private_route" {
  count          = 1
  subnet_id      = aws_subnet.private.*.id[count.index]
  route_table_id = aws_route_table.private_route.id
}

#####################
####    6. EIP   ####
#####################

resource "aws_eip" "nat" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.resource_prefix}-NAT"
  }
}
