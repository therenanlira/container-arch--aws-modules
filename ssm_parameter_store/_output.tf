# Variables

output "service_name" {
  value = var.service_name
}

# SSM Parameter Store

output "arn" {
  value = aws_ssm_parameter.main.arn
}
