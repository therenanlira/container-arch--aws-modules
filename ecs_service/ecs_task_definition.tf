# Elastic Container Registry

data "external" "ecr_latest_image" {
  program = ["bash", "${path.module}/scripts/check_ecr_latest_tag.sh"]

  query = {
    repository_name = aws_ecr_repository.main.name
  }
}

locals {
  default_app_image_tag = data.external.ecr_latest_image.result.tag
}

resource "aws_ecr_repository" "main" {
  name         = trimsuffix(local.name_prefix, "-")
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(local.tags, {
    Name = trimsuffix(local.name_prefix, "-")
  })
}

# Task Definition

resource "aws_ecs_task_definition" "main" {
  family = "${local.name_prefix}-taskdef"

  network_mode             = "awsvpc"
  requires_compatibilities = var.capabilities

  cpu    = var.service_cpu
  memory = var.service_mem

  execution_role_arn = aws_iam_role.ecs_service_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name   = var.service_name
    image  = "${aws_ecr_repository.main.repository_url}:${local.default_app_image_tag}"
    cpu    = var.service_cpu
    memory = var.service_mem

    essential = true

    portMappings = [{
      containerPort = var.service_port
      hostPort      = var.service_port
      protocol      = "tcp"
    }]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.main.id
        awslogs-region        = data.aws_region.current.region
        awslogs-stream-prefix = var.service_name
      }
    }

    environment = var.environment_variables
  }])

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-taskdef"
  })
}
