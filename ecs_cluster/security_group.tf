# Security Group - Load Balancer
resource "aws_security_group" "load_balancer" {
  name = "${local.name_prefix}-lb-sg"

  vpc_id = var.network_values.vpc_id

  tags = {
    Name = "${local.name_prefix}-lb-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "load_balancer_outbound_all" {
  security_group_id = aws_security_group.load_balancer.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "${local.name_prefix}-lb-sg outbound all"
  }
}

resource "aws_vpc_security_group_ingress_rule" "load_balancer_inbound_http" {
  security_group_id = aws_security_group.load_balancer.id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "${local.name_prefix}-lb-sg inbound http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "load_balancer_inbound_https" {
  security_group_id = aws_security_group.load_balancer.id

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "${local.name_prefix}-lb-sg inbound https"
  }
}

# Security Group - VPC Link

resource "aws_security_group" "vpclink" {
  count = var.enable_vpclink ? 1 : 0

  name = "${local.name_prefix}-vpclink-sg"

  vpc_id = var.network_values.vpc_id

  tags = {
    Name = "${local.name_prefix}-vpclink-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "vpclink_outbound_all" {
  count = var.enable_vpclink ? 1 : 0

  security_group_id = aws_security_group.vpclink[count.index].id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "${local.name_prefix}-vpclink-sg outbound all"
  }
}

resource "aws_vpc_security_group_ingress_rule" "vpclink_inbound_http" {
  count = var.enable_vpclink ? 1 : 0

  security_group_id = aws_security_group.vpclink[count.index].id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "${local.name_prefix}-vpclink-sg inbound http"
  }
}
