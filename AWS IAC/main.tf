# Create a VPC with two public and two private subnets
resource "aws_vpc" "nuvei_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.nuvei_vpc.id
  cidr_block        = var.public_subnet[0]
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "${var.business_name}-public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.nuvei_vpc.id
  cidr_block        = var.public_subnet[1]
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "${var.business_name}-public-subnet-2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.nuvei_vpc.id
  cidr_block        = var.private_subnet[0]
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "${var.business_name}-private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.nuvei_vpc.id
  cidr_block        = var.private_subnet[1]
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "${var.business_name}-private-subnet-2"
  }
}

# Create route tables for each subnet
resource "aws_route_table" "public_subnet_1_rt" {
  vpc_id = aws_vpc.nuvei_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-subnet-1-route-table"
  }
}

resource "aws_route_table" "public_subnet_2_rt" {
  vpc_id = aws_vpc.nuvei_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-subnet-2-route-table"
  }
}

resource "aws_route_table" "private_subnet_1_rt" {
  vpc_id = aws_vpc.nuvei_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "private-subnet-1-route-table"
  }
}

resource "aws_route_table" "private_subnet_2_rt" {
  vpc_id = aws_vpc.nuvei_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "private-subnet-2-route-table"
  }
}

# Associate the subnets with their respective route tables
resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_subnet_1_rt.id
}

resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_subnet_2_rt.id
}

resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_subnet_1_rt.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_subnet_2_rt.id
}

# Create igw
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.nuvei_vpc.id

  tags = {
    Name = "${var.business_name}-igw"
  }
}

# Create an Elastic IP address
resource "aws_eip" "eip" {
  vpc = true
}

# Create a NAT Gateway in the public subnet and associate it with the Elastic IP address
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet_1.id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.business_name}-nat-gateway"
  }
}

# Create a public Route53 hosted zone and CNAME entry for the ELB
resource "aws_route53_zone" "Nuvei_zone" {
  name = var.domain
}

resource "aws_route53_record" "nuvei_cname" {
  name    = var.domain
  type    = "CNAME"
  ttl     = "300"
  records = [aws_elb.nuvei_elb.dns_name]
  zone_id = aws_route53_zone.Nuvei_zone.zone_id
}