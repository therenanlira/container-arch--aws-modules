locals {
  subnet_ids = [for k, v in var.network_values.private_subnet_ids : v]
}

# ECS Service

resource "aws_ecs_service" "main" {
  name    = var.service_name
  cluster = var.cluster_name

  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.task_count

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100


  dynamic "service_registries" {
    for_each = var.service_discovery_namespace != null ? [1] : []
    content {
      registry_arn   = aws_service_discovery_service.main[0].arn
      container_name = var.service_name
    }
  }

  dynamic "ordered_placement_strategy" {
    for_each = contains(var.service_launch_type, "EC2") ? [1] : []
    content {
      type  = "spread"
      field = "attribute:ecs.availability-zone"
    }
  }

  dynamic "capacity_provider_strategy" {
    for_each = var.service_launch_type
    content {
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = capacity_provider_strategy.value.weight
    }
  }

  dynamic "service_connect_configuration" {
    for_each = var.enable_service_connect ? [1] : []

    content {
      enabled   = var.enable_service_connect
      namespace = var.service_connect_name

      service {
        port_name      = var.service_name
        discovery_name = var.service_name

        client_alias {
          port     = var.service_port
          dns_name = "${var.service_name}.${var.service_connect_name}"
        }
      }

    }
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

  dynamic "load_balancer" {
    for_each = var.enable_lb ? [1] : []
    content {
      target_group_arn = local.target_group_arn
      container_name   = var.service_name
      container_port   = var.service_port
    }
  }

  platform_version = contains(var.service_launch_type, "EC2") ? null : "LATEST"

  lifecycle {
    ignore_changes = [
      desired_count
    ]
  }
}
