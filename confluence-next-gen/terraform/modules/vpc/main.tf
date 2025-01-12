# Create vpc
resource aws_vpc "confl-vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "confl-vpc"
    Project = var.project
  }
}

# Create Internet Gateway and attached to vpc
resource aws_internet_gateway "confl-igw" {
  vpc_id = aws_vpc.confl-vpc.id
  tags = {
    Name = "confl-igw"
    Project = var.project
  }
}

# Create public subnets
resource aws_subnet "confl-pub-sub" {
  for_each = var.pub_subnets
  vpc_id = aws_vpc.confl-vpc.id
  cidr_block = each.value
  availability_zone = each.key
  map_public_ip_on_launch = true
  tags = {
    Name = "confl-pub-${each.key}"
    Project = var.project
  }
}

# Create public routing table and direct all traffic to igw
resource aws_route_table "confl-pub-rtb" {
  vpc_id = aws_vpc.confl-vpc.id
  route {
    cidr_block = var.all_cidr
    gateway_id = aws_internet_gateway.confl-igw.id
  }
  tags = {
    Name = "confl-pub-rtb"
    Project = var.project
  }
}

# Attach public route table to public subnets
resource aws_route_table_association "confl-pub-rta" {
  for_each = aws_subnet.confl-pub-sub
  route_table_id = aws_route_table.confl-pub-rtb.id
  subnet_id = aws_subnet.confl-pub-sub[each.key].id
}

