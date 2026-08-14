# Variables

output "service_name" {
  value = var.service_name
}

output "environment" {
  value = var.environment
}

# ECR

output "name" {
  value = aws_ecr_repository.main.name
}

output "repository_url" {
  value = aws_ecr_repository.main.repository_url
}
