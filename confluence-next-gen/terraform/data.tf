data "aws_kms_secrets" "confl-secrets" {
  secret {
    name    = "rds_secret"
    payload = var.rds.db_pass
  }
}

# Find a certificate that is issued
data "aws_acm_certificate" "astrix-issued" {
  domain   = var.domain
  statuses = ["ISSUED"]
}

//data "aws_subnets" "vpc" {
//  filter {
//    name   = "vpc-id"
//    values = [var.vpc_id]
//  }
//}
//
//data "aws_subnet" "subnets" {
//  for_each = toset(data.aws_subnets.vpc.id)
//  id       = each.value
//}
//
//output "subnet_cidr_blocks" {
//  value = [for s in data.aws_subnet.subnets : s.cidr_block]
//}
//
//output "subnet_id_1a" {
//  value = [for s in data.aws_subnet.subnets : s.id if s.availability_zone == "us-east-1a"]
//}
//
//output "subnet_id_1b" {
//  value = [for s in data.aws_subnet.subnets : s.id if s.availability_zone == "us-east-1b"]
//}

#output "subnet_ids-tmp" {
#  value = local.subnet-east-1a
#}