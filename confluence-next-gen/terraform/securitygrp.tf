# create a list of confluence security groups
resource "aws_security_group" "confl-sgs-stack" {
  for_each    = var.security_group_stack
  vpc_id      = module.vpc.vpc_id
  name        = each.value.sg_name
  description = each.value.description
  tags = {
    Name    = each.value.sg_name
    Project = var.project
  }
  lifecycle {
    create_before_destroy = true
  }
}

# create a list of ingress rules and assign to its associated security group
resource "aws_vpc_security_group_ingress_rule" "confl-ingress-stack" {
  for_each                     = var.confl_ingress_sgs_vars_stack
  security_group_id            = aws_security_group.confl-sgs-stack[each.value.security_group].id
  cidr_ipv4                    = each.key == "allow-http-from-lb" ? null : each.value.cidr_ipv4
  from_port                    = each.value.from_port
  ip_protocol                  = each.value.ip_protocol
  to_port                      = each.value.to_port
  referenced_security_group_id = each.key == "allow-http-from-lb" ? aws_security_group.confl-sgs-stack[var.sg_keys.alb].id : each.value.referenced_security_group_id
}

# create a list of egress rules and assign to its associated security group
resource "aws_vpc_security_group_egress_rule" "confl-egress-stack" {
  for_each          = var.confl_egress_sgs_vars_stack
  security_group_id = aws_security_group.confl-sgs-stack[each.value.security_group].id
  cidr_ipv4         = each.value.cidr_ipv4
  ip_protocol       = each.value.ip_protocol # "-1":  semantically equivalent to all ports
}
