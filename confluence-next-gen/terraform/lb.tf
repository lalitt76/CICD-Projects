# create application load balancer
resource "aws_lb" "confl-alb" {
  name               = "confl-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.confl-sgs-stack[var.sg_keys.alb].id]
  subnets = [
    module.vpc.pub_sub_01,
    module.vpc.pub_sub_02
  ]
}

# create alb listener and attached to lb and target group
resource "aws_lb_listener" "confl-lb-lsn" {
  load_balancer_arn = aws_lb.confl-alb.arn
  protocol          = "HTTP"
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.confl-lb-tg.arn
  }
}

//# request and validate an SSL certificate from aws certificate manager
//resource "aws_acm_certificate" "ssl-certificate" {
//  domain_name       = var.domain
//  validation_method = "DNS"
//  tags = {
//    Name : "${var.domain}-ssl-certificate"
//  }
//}

//# associate the ssl certificate with alb listener
//resource "aws_lb_listener_certificate" "confl-certificate" {
//  certificate_arn = aws_acm_certificate.ssl-certificate.arn
//  listener_arn    = aws_lb_listener.confl-lb-lsn.arn
//}

# create lb target group and it's properties
resource "aws_lb_target_group" "confl-lb-tg" {
  vpc_id   = module.vpc.vpc_id
  name     = "confl-lb-tg"
  port     = 8090
  protocol = "HTTP"

  stickiness {
    type    = "lb_cookie"
    enabled = true
  }
  health_check {
    enabled             = true
    port                = 8090
    interval            = 30
    protocol            = "HTTP"
    path                = "/status"
    matcher             = "200"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}


# attached ec2 instances with alb target group
resource "aws_lb_target_group_attachment" "confl-tg-atm" {
  for_each         = local.confluence
  target_group_arn = aws_lb_target_group.confl-lb-tg.arn
  target_id        = aws_instance.confl-servers[each.key].id
  port             = 8090
}