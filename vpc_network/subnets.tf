# Private, Public and Data Subnets

resource "aws_subnet" "these_private" {
  for_each = local.vpc_azs

  vpc_id            = aws_vpc.main.id
  availability_zone = each.key
  cidr_block        = cidrsubnet(local.subnet_private_blocks, 2, index(data.aws_availability_zones.available.names, each.key))

  tags = {
    Name = "${local.name_prefix}-private-subnet-${each.key}"
  }
}

resource "aws_subnet" "these_public" {
  for_each = local.vpc_azs

  vpc_id            = aws_vpc.main.id
  availability_zone = each.key
  cidr_block        = cidrsubnet(local.subnet_public_blocks, 4, index(data.aws_availability_zones.available.names, each.key))

  tags = {
    Name = "${local.name_prefix}-public-subnet-${each.key}"
  }
}

resource "aws_subnet" "these_data" {
  for_each = local.vpc_azs

  vpc_id            = aws_vpc.main.id
  availability_zone = each.key
  cidr_block        = cidrsubnet(local.subnet_data_blocks, 4, index(data.aws_availability_zones.available.names, each.key))

  tags = {
    Name = "${local.name_prefix}-data-subnet-${each.key}"
  }
}
