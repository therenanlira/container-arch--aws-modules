# Variables

output "project_name" {
  value = var.project_name
}

output "environment" {
  value = var.environment
}

output "network_values" {
  value = var.network_values
}

output "capacity_provider_strategies" {
  value = var.capacity_provider_strategies
}

output "ecs_autoscaling" {
  value = var.ecs_autoscaling
}

output "ecs_ami" {
  value = var.ecs_ami
}

output "ecs_instance_type" {
  value = var.ecs_instance_type
}

output "ecs_volume_size" {
  value = var.ecs_volume_size
}

output "ecs_volume_type" {
  value = var.ecs_volume_type
}

output "load_balancer_internal" {
  value = var.load_balancer_internal
}

output "load_balancer_type" {
  value = var.load_balancer_type
}

output "user_data_template" {
  value = var.user_data_template
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
