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

output "dns_zone_id" {
  value = var.dns_zone_id
}

output "dns_name" {
  value = var.dns_name
}

output "service_discovery_namespace" {
  value = var.service_discovery_namespace
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

output "task_count" {
  value = var.task_count
}

output "service_hosts" {
  value = var.service_hosts
}

output "enable_service_connect" {
  value = var.enable_service_connect
}

output "service_connect_name" {
  value = var.service_connect_name
}

output "service_protocol" {
  value = var.service_protocol
}

output "protocol" {
  value = var.protocol
}

output "enable_lb" {
  value = var.enable_lb
}

output "service_listener" {
  value = var.service_listener
}

output "alb_arn" {
  value = var.alb_arn
}

output "alb_dns_name" {
  value = var.alb_dns_name
}

output "alb_zone_id" {
  value = var.alb_zone_id
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

output "container_image" {
  value = var.container_image
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

output "target_group_arn" {
  value = local.target_group_arn
}

