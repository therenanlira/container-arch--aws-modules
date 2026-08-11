# Variables

output "listener_arn" {
  value = var.listener_arn
}

output "endpoint_group_region" {
  value = var.endpoint_group_region
}

output "endpoints" {
  value = var.endpoints
}

output "traffic_dial_percentage" {
  value = var.traffic_dial_percentage
}

# Endpoint Group

output "arn" {
  value = aws_globalaccelerator_endpoint_group.main.arn
}
