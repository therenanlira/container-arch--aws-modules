locals {
  subnet_ids = [for k, v in var.network_values.private_subnet_ids : v]
}

# ECS Service

resource "aws_ecs_service" "main" {
  name    = var.service_name
  cluster = var.cluster_name

  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.service_task_count
  launch_type     = var.service_launch_type

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  ordered_placement_strategy {
    type  = strcontains(var.service_launch_type, "EC2") ? "spread" : null
    field = strcontains(var.service_launch_type, "EC2") ? "attribute:ecs.availability-zone" : null
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    security_groups  = [aws_security_group.ecs_service.id]
    subnets          = local.subnet_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.main.arn
    container_name   = var.service_name
    container_port   = var.service_port
  }

  platform_version = strcontains(var.service_launch_type, "EC2") ? null : "LATEST"

  lifecycle {
    ignore_changes = [
      desired_count
    ]
  }
}
