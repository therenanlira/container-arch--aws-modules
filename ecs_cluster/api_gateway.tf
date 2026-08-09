# Load Balancer - VPC Link

resource "aws_lb" "vpclink" {
  count = var.enable_vpclink ? 1 : 0

  name = "${local.name_prefix}-vpclink-lb"

  internal           = true
  load_balancer_type = "network"

  subnets         = [for sub in var.network_values.private_subnet_ids : sub]
  security_groups = [aws_security_group.vpclink[count.index].id]

  enable_cross_zone_load_balancing = false
  enable_deletion_protection       = false

  tags = {
    Name = "${local.name_prefix}-vpclink-lb"
  }
}

resource "aws_lb_target_group" "vpclink" {
  count = var.enable_vpclink ? 1 : 0

  name = "${local.name_prefix}-vpclink-tg"

  vpc_id = var.network_values.vpc_id

  port        = 80
  protocol    = "TCP"
  target_type = "alb"

  target_health_state {
    enable_unhealthy_connection_termination = false
  }

  tags = {
    Name = "${local.name_prefix}-vpclink-tg"
  }
}

resource "aws_lb_listener" "vpclink" {
  count = var.enable_vpclink ? 1 : 0

  load_balancer_arn = aws_lb.vpclink[count.index].arn

  port     = 80
  protocol = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vpclink[count.index].arn
  }

  tags = {
    Name = "${local.name_prefix}-vpclink-lb-listener"
  }
}

resource "aws_lb_target_group_attachment" "vpclink" {
  count = var.enable_vpclink ? 1 : 0

  target_group_arn = aws_lb_target_group.vpclink[count.index].arn
  target_id        = aws_lb.main.id
  port             = 80

  depends_on = [
    aws_lb_listener.main
  ]
}

# API Gateway - VPC Link

resource "aws_api_gateway_vpc_link" "main" {
  count = var.enable_vpclink ? 1 : 0

  name = "${local.name_prefix}-vpclink-apigw"

  target_arns = [
    aws_lb.vpclink[count.index].arn
  ]
}
