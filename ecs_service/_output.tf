########################################
########### Variables
########################################

output "network_values" {
  description = "The network configuration for the ECS cluster"
  value       = var.network_values
}

output "cluster_name" {
  description = "The ARN of the ECS cluster where the service is deployed"
  value       = var.cluster_name
}

output "service_name" {
  description = "The name of the ECS service"
  value       = var.service_name
}

output "service_port" {
  description = "The port on which the service is listening"
  value       = var.service_port
}

output "service_cpu" {
  description = "The number of CPU units reserved for the service"
  value       = var.service_cpu
}

output "service_mem" {
  description = "The amount of memory (in MiB) reserved for the service"
  value       = var.service_mem
}

