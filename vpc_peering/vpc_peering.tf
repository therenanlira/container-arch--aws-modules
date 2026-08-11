# VPC Peering Request

resource "aws_vpc_peering_connection" "request" {
  peer_owner_id = var.target_account_id
  peer_vpc_id   = var.target_vpc_id
  peer_region   = var.target_region
  vpc_id        = var.network_values.vpc_id

  tags = {
    Name = local.service_name
  }
}

resource "aws_route" "request" {
  for_each = var.network_values.private_route_table_ids

  route_table_id            = each.value
  destination_cidr_block    = var.target_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.acceptance.id
}

# VPC Peering Acceptance

resource "aws_vpc_peering_connection_accepter" "acceptance" {
  provider = aws.central

  vpc_peering_connection_id = aws_vpc_peering_connection.request.id
  auto_accept               = true

  tags = {
    Name = local.service_name
  }
}

resource "aws_route" "acceptance" {
  for_each = var.target_route_table_ids

  provider = aws.central

  route_table_id            = each.value
  destination_cidr_block    = var.network_values.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.acceptance.id
}
