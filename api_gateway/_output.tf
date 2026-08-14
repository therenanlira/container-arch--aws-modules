# Variables

output "project_name" {
  value = var.project_name
}

output "body_file" {
  value = var.body_file
}

output "invoke_url" {
  value = aws_api_gateway_stage.main.invoke_url
}

output "environment" {
  value = var.environment
}

output "service_name" {
  value = var.service_name
}

output "api_key_names" {
  value = var.api_key_names
}

output "enable_log" {
  value = var.enable_log
}

output "dns_name" {
  value = var.dns_name
}

output "route53_zone_id" {
  value = var.route53_zone_id
}

output "certificate_arn" {
  value = var.certificate_arn
}

output "base_mapping" {
  value = var.base_mapping
}
