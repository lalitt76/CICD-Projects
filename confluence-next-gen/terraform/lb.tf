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
  tags = {
    Name : "confl-alb"
    Project : var.project
  }
}

# create alb listener for https and attached to lb and confluence target group
resource "aws_lb_listener" "confl-lb-confl-lsn" {
  load_balancer_arn = aws_lb.confl-alb.arn
  protocol          = "HTTPS"
  port              = "443"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.astrix-issued.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.confl-lb-confl-tg.arn
  }
}


# create lb target group for confluence and it's properties
resource "aws_lb_target_group" "confl-lb-confl-tg" {
  vpc_id   = module.vpc.vpc_id
  name     = "confl-lb-confl-tg"
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
  tags = {
    Name : "confl-lb-confl-tg"
    Project : var.project
  }
}


# attached confluence ec2 instances with alb target group
resource "aws_lb_target_group_attachment" "confl-tg-confl-atm" {
  for_each         = local.confluence
  target_group_arn = aws_lb_target_group.confl-lb-confl-tg.arn
  target_id        = aws_instance.confl-servers[each.key].id
  port             = 8090
}

# create lb target group for synchrony and it's properties
resource "aws_lb_target_group" "confl-lb-sync-tg" {
  vpc_id   = module.vpc.vpc_id
  name     = "confl-lb-sync-tg"
  port     = 8091
  protocol = "HTTP"

  stickiness {
    type    = "lb_cookie"
    enabled = true
  }
  health_check {
    enabled             = true
    port                = 8091
    interval            = 30
    protocol            = "HTTP"
    path                = "/synchrony/heartbeat"
    matcher             = "200"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
  tags = {
    Name : "confl-lb-sync-tg"
    Project : var.project
  }
}

# attach synchrony ec2 instances with alb target group
resource "aws_lb_target_group_attachment" "confl-tg-sync-atm" {
  for_each         = local.synchrony
  target_group_arn = aws_lb_target_group.confl-lb-sync-tg.arn
  target_id        = aws_instance.confl-servers[each.key].id
  port             = 8091
}

# create synchrony alb listener and attach to lb and target group
resource "aws_lb_listener" "confl-lb-sync-lsn" {
  load_balancer_arn = aws_lb.confl-alb.arn
  protocol          = "HTTP"
  port              = "80"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.confl-lb-sync-tg.arn
  }
}