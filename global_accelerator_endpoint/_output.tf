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

output "health_check_protocol" {
  value = var.health_check_protocol
}

output "health_check_path" {
  value = var.health_check_path
}

output "health_check_port" {
  value = var.health_check_port
}

output "health_check_interval_seconds" {
  value = var.health_check_interval_seconds
}

output "threshold_count" {
  value = var.threshold_count
}

# Endpoint Group

output "arn" {
  value = aws_globalaccelerator_endpoint_group.main.arn
}
