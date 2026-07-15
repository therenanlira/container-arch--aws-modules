# Load Balancer

resource "aws_lb" "main" {
  name = "${local.name_prefix}-lb"

  internal           = var.load_balancer_internal
  load_balancer_type = var.load_balancer_type

  subnets         = [for sub in var.network_values.public_subnet_ids : sub]
  security_groups = [aws_security_group.load_balancer.id]

  enable_cross_zone_load_balancing = false
  enable_deletion_protection       = false

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-lb"
  })
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

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-lb-listener"
  })
}

# Load Balancer Security Group

resource "aws_security_group" "load_balancer" {
  name = "${local.name_prefix}-lb-sg"

  vpc_id = var.network_values.vpc_id

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-lb-sg"
  })
}

resource "aws_vpc_security_group_egress_rule" "load_balancer_outbound_all" {
  security_group_id = aws_security_group.load_balancer.id

  from_port   = 0
  to_port     = 0
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-lb-sg outbound all"
  })
}

resource "aws_vpc_security_group_ingress_rule" "load_balancer_inbound_http" {
  security_group_id = aws_security_group.load_balancer.id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-lb-sg inbound http"
  })
}

resource "aws_vpc_security_group_ingress_rule" "load_balancer_inbound_https" {
  security_group_id = aws_security_group.load_balancer.id

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-lb-sg inbound https"
  })
}
