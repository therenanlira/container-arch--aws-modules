# VPC and IGW

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.name_prefix}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-igw"
  }
}

resource "aws_eip" "eip" {
  for_each = local.vpc_azs

  domain = "vpc"

  tags = {
    Name = "${local.name_prefix}-eip-${each.key}"
  }
}

resource "aws_nat_gateway" "natgw" {
  for_each = local.vpc_azs

  allocation_id = aws_eip.eip[each.key].id
  subnet_id     = aws_subnet.these_public[each.key].id

  tags = {
    Name = "${local.name_prefix}-natgw-${each.key}"
  }
}
