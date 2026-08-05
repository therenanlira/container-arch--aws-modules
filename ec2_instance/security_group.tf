# Security Group

resource "aws_security_group" "ec2" {
  name = "${local.name_prefix}-sg"

  vpc_id = var.network_values.vpc_id

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-sg"
  })
}

resource "aws_vpc_security_group_egress_rule" "ec2_outbound_all" {
  security_group_id = aws_security_group.ec2.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-sg outbound all"
  })
}

resource "aws_vpc_security_group_ingress_rule" "ec2_inbound_ssh" {
  for_each = toset(var.allowed_ssh_cidrs)

  security_group_id = aws_security_group.ec2.id

  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  cidr_ipv4   = each.value

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-sg inbound ssh"
  })
}
