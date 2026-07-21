# Variables

output "network_values" {
  value = var.network_values
}

output "project_name" {
  value = var.project_name
}

output "cluster_name" {
  value = var.cluster_name
}

output "service_name" {
  value = var.service_name
}

output "service_port" {
  value = var.service_port
}

output "service_cpu" {
  value = var.service_cpu
}

output "service_mem" {
  value = var.service_mem
}

output "service_healthcheck" {
  value = var.service_healthcheck
}

output "service_launch_type" {
  value = var.service_launch_type
}

output "service_task_count" {
  value = var.service_task_count
}

output "service_hosts" {
  value = var.service_hosts
}

output "alb_arn" {
  value = var.alb_arn
}

output "scale_type" {
  value = var.scale_type
}

output "scale_tracking_cpu" {
  value = var.scale_tracking_cpu
}

output "scale_tracking_requests" {
  value = var.scale_tracking_requests
}

output "task_min" {
  value = var.task_min
}

output "task_max" {
  value = var.task_max
}

output "scale_out_cpu" {
  value = var.scale_out_cpu
}

output "scale_in_cpu" {
  value = var.scale_in_cpu
}

output "capabilities" {
  value = var.capabilities
}

output "environment_variables" {
  value = var.environment_variables
}

output "secrets" {
  value = var.secrets
}

output "efs_volumes" {
  value = var.efs_volumes
}
