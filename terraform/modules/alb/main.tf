locals {
  common_tags = {
    project = var.name
    environment = var.environment
  }
}

resource "aws_lb" "this" {
  name               = "${var.name}-${var.environment}-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [var.alb_sg_id]

  tags = local.common_tags
}

resource "aws_lb_target_group" "this" {
  name        = "${var.name}-${var.environment}-tg"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  tags = local.common_tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  tags = local.common_tags
}
