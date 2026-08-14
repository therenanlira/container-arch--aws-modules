# Variables

output "project_name" {
  value = var.project_name
}

output "service_name" {
  value = var.service_name
}

output "environment" {
  value = var.environment
}

output "dynamodb_values" {
  value = var.dynamodb_values
}

output "arn" {
  value = aws_dynamodb_table.main.arn
}

output "name" {
  value = aws_dynamodb_table.main.name
}
