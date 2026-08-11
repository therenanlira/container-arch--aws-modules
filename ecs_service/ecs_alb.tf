# ALB Target Group

resource "aws_alb_target_group" "main" {
  for_each = var.enable_lb && strcontains(var.deployment_controller, "ECS") ? (
    toset(local.target_group_keys)) : (
    toset([])
  )

  name = "${substr("${local.name_prefix}", 0, 26)}-${substr(each.value, 0, 1)}-tg"

  port        = var.service_port
  vpc_id      = var.network_values.vpc_id
  protocol    = "HTTP"
  target_type = "ip"

  deregistration_delay = var.deregistration_delay

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

  tags = {
    Name = "${substr("${local.name_prefix}", 0, 26)}-${substr(each.value, 0, 1)}-tg"
  }
}

resource "aws_alb_target_group" "codedeploy" {
  for_each = var.enable_lb && strcontains(var.deployment_controller, "CODE_DEPLOY") ? (
    toset(["blue", "green"])) : (
    toset([])
  )

  name = "${substr("${local.name_prefix}", 0, 26)}-${substr(each.value, 0, 1)}-tg"

  port        = var.service_port
  vpc_id      = var.network_values.vpc_id
  protocol    = "HTTP"
  target_type = "ip"

  deregistration_delay = var.deregistration_delay

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

  tags = {
    Name = "${substr("${local.name_prefix}", 0, 26)}-${substr(each.value, 0, 1)}-tg"
  }
}

# ALB Listener Rule

resource "aws_alb_listener_rule" "main" {
  count        = var.enable_lb && strcontains(var.deployment_controller, "ECS") && !local.ecs_blue_green ? 1 : 0
  listener_arn = var.service_listener

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.main["rolling"].arn
  }

  condition {
    host_header {
      values = var.service_hosts
    }
  }
}

resource "aws_alb_listener_rule" "blue_green" {
  count = var.enable_lb && local.ecs_blue_green ? 1 : 0

  listener_arn = var.service_listener

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.main["blue"].arn
  }

  condition {
    host_header {
      values = var.service_hosts
    }
  }

  lifecycle {
    ignore_changes = [
      action
    ]
  }
}

resource "aws_alb_listener_rule" "codedeploy" {
  count = var.enable_lb && strcontains(var.deployment_controller, "CODE_DEPLOY") ? 1 : 0

  listener_arn = var.service_listener

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_alb_target_group.codedeploy["blue"].arn
        weight = 100
      }
      target_group {
        arn    = aws_alb_target_group.codedeploy["green"].arn
        weight = 0
      }
    }
  }

  condition {
    host_header {
      values = var.service_hosts
    }
  }

  lifecycle {
    ignore_changes = [
      action
    ]
  }
}
