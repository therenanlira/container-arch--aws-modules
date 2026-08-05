# ALB Target Group

resource "aws_alb_target_group" "main" {
  count = var.enable_lb ? 1 : 0

  name = local.target_group_name

  port        = var.service_port
  vpc_id      = var.network_values.vpc_id
  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    healthy_threshold   = lookup(var.service_healthcheck, "healthy_threshold", "3")
    unhealthy_threshold = lookup(var.service_healthcheck, "unhealthy_threshold", "10")
    timeout             = lookup(var.service_healthcheck, "timeout", "10")
    interval            = lookup(var.service_healthcheck, "interval", "60")
    matcher             = lookup(var.service_healthcheck, "matcher", "200")
    path                = lookup(var.service_healthcheck, "path", "/healthcheck")
    port                = lookup(var.service_healthcheck, "port", var.service_port)
  }

  lifecycle {
    create_before_destroy = false
  }
}

# ALB Listener Rule

resource "aws_alb_listener_rule" "main" {
  count        = var.enable_lb ? 1 : 0
  listener_arn = var.service_listener

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.main[0].arn
  }

  condition {
    host_header {
      values = var.service_hosts
    }
  }
}
