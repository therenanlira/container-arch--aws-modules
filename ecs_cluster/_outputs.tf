# Variables

output "project_name" {
  description = "The name of the project, used for tagging and naming resources."
  value       = var.project_name
}

output "environment" {
  description = "The deployment environment (e.g., 'dev', 'staging', 'prod')."
  value       = var.environment
}

output "network_values" {
  description = "The network configuration for the ECS cluster, including VPC and subnets."
  value       = var.network_values
}

output "capacity_provider_strategies" {
  description = "A list of capacity provider strategies to use for the ECS cluster (e.g., ['on_demand', 'spot'])."
  value       = var.capacity_provider_strategies
}

output "ecs_autoscaling" {
  description = "A map of autoscaling configurations for each capacity provider strategy."
  value       = var.ecs_autoscaling
}

output "ecs_ami" {
  description = "The AMI ID to use for the ECS instances."
  value       = var.ecs_ami
}

output "ecs_instance_type" {
  description = "The instance type to use for the ECS instances."
  value       = var.ecs_instance_type
}

output "ecs_volume_size" {
  description = "The size of the EBS volume to attach to each ECS instance (in GB)."
  value       = var.ecs_volume_size
}

output "ecs_volume_type" {
  description = "The type of the EBS volume to attach to each ECS instance (e.g., 'gp2', 'gp3')."
  value       = var.ecs_volume_type
}

output "load_balancer_internal" {
  description = "Whether the load balancer should be internal or internet-facing."
  value       = var.load_balancer_internal
}

output "load_balancer_type" {
  description = "The type of load balancer to use (e.g., 'application', 'network')."
  value       = var.load_balancer_type
}

output "user_data_template" {
  description = "The user data template for the ECS instances."
  value       = var.user_data_template
}

# ECS Cluster

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

# Load Balancer

output "lb_arn" {
  value = aws_lb.main.arn
}

output "lb_dns_name" {
  value = aws_lb.main.dns_name
}

output "lb_listener_arn" {
  value = aws_lb_listener.main.arn
}
