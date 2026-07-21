# Variables

output "service_name" {
  value = var.service_name
}

# SSM Secrets Manager

output "arn" {
  value = aws_secretsmanager_secret.main.arn
}
