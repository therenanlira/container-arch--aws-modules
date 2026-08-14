# Variables

output "service_name" {
  value = var.service_name
}

output "performance_mode" {
  value = var.performance_mode
}

output "throughput_mode" {
  value = var.throughput_mode
}

output "environment" {
  value = var.environment
}

output "network_values" {
  value = var.network_values
}

# General

output "arn" {
  value = aws_efs_file_system.main.arn
}

output "id" {
  value = aws_efs_file_system.main.id
}

output "name" {
  value = aws_efs_file_system.main.name
}
