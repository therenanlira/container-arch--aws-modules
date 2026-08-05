# Security Group

resource "aws_security_group" "ecs_service" {
  name = "${local.name_prefix}-ecs-sg"

  vpc_id = var.network_values.vpc_id

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-ecs-sg"
  })
}

resource "aws_vpc_security_group_egress_rule" "ecs_service_outbound_all" {
  security_group_id = aws_security_group.ecs_service.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-ecs-sg outbound all"
  })
}

resource "aws_vpc_security_group_ingress_rule" "ecs_service_inbound_service_vpc" {
  security_group_id = aws_security_group.ecs_service.id

  from_port   = var.service_port
  to_port     = var.service_port
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-ecs-sg inbound service port"
  })
}

resource "aws_vpc_security_group_ingress_rule" "ecs_service_inbound_all_vpc" {
  security_group_id = aws_security_group.ecs_service.id

  from_port   = 0
  to_port     = 65535
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-ecs-sg inbound all tcp"
  })
}
