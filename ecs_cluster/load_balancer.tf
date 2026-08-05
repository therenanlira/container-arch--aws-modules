# Load Balancer

resource "aws_lb" "main" {
  name = "${local.name_prefix}-lb"

  internal           = var.load_balancer_internal
  load_balancer_type = strcontains(var.load_balancer_internal, "true") ? "application" : var.load_balancer_type

  subnets         = [for sub in var.network_values.public_subnet_ids : sub]
  security_groups = [aws_security_group.load_balancer.id]

  enable_cross_zone_load_balancing = false
  enable_deletion_protection       = false

  tags = {
    Name = "${local.name_prefix}-lb"
  }
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn

  port     = "80"
  protocol = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Container Arch"
      status_code  = "200"
    }
  }

  tags = {
    Name = "${local.name_prefix}-lb-listener"
  }
}
