resource "aws_lb" "this" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "application"

  security_groups = var.security_group_ids
  subnets         = var.subnet_ids

  enable_deletion_protection = false
  enable_http2               = true

  tags = var.tags
}

resource "aws_lb_target_group" "this" {
  for_each = var.target_groups

  name        = each.key
  port        = each.value.port
  protocol    = each.value.protocol
  target_type = each.value.target_type
  vpc_id      = var.vpc_id

  health_check {
    path = each.value.health_check_path
  }

  tags = var.tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = values(aws_lb_target_group.this)[0].arn
  }
}
