# vpc id
output "vpc_id" {
  value = aws_vpc.confl-vpc.id
}

# vpc cidr block
output "vpc_cidr" {
  value = aws_vpc.confl-vpc.cidr_block
}

#public subnets
output "public_subnets" {
  value = aws_subnet.confl-pub-sub
}


# first public subnet
output "pub_sub_01" {
  value = aws_subnet.confl-pub-sub[var.av_zones.zone1].id
}

# first public subnet cidr
output "pub_sub_01_cidr" {
  value = var.pub_subnets.us-east-1a
}

# second public subnet
output "pub_sub_02" {
  value = aws_subnet.confl-pub-sub[var.av_zones.zone2].id
}

# second public subnet cidr
output "pub_sub_02_cidr" {
  value = var.pub_subnets.us-east-1b
}
