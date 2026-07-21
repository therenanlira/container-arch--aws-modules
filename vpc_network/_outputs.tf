# Variables
output "project_name" {
  value = var.project_name
}

output "cidr_block" {
  value = var.cidr_block
}

output "subnet_count" {
  value = var.subnet_count
}

output "vpce_gateways" {
  value = var.vpce_gateways
}

# Network

output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnet_ids" {
  value = { for az in local.vpc_azs : az => aws_subnet.these_private[az].id }
}

output "public_subnet_ids" {
  value = { for az in local.vpc_azs : az => aws_subnet.these_public[az].id }
}

output "data_subnet_ids" {
  value = { for az in local.vpc_azs : az => aws_subnet.these_data[az].id }
}
