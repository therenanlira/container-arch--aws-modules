# Variables

output "service_name" {
  value = var.service_name
}

output "environment" {
  value = var.environment
}

# Global Accelerator

output "global_accelerator_id" {
  value = aws_globalaccelerator_accelerator.main.id
}

output "global_accelerator_dns" {
  value = aws_globalaccelerator_accelerator.main.dns_name
}

output "global_accelerator_ip_sets" {
  value = aws_globalaccelerator_accelerator.main.ip_sets
}

output "global_accelerator_hosted_zone_id" {
  value = aws_globalaccelerator_accelerator.main.hosted_zone_id
}

# Listener

output "listener_arn" {
  value = aws_globalaccelerator_listener.main.arn
}
