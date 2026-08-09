# Elastic Container Registry

data "external" "ecr_latest_image" {
  count   = var.container_image == "" ? 1 : 0
  program = ["bash", "${path.module}/scripts/check_ecr_latest_tag.sh"]

  query = {
    repository_name = module.ecr_repository[count.index].name
  }
}

locals {
  default_app_image_tag = var.container_image == "" ? data.external.ecr_latest_image[0].result.tag : var.container_image
  container_image       = var.container_image == "" ? "${module.ecr_repository[0].repository_url}:${local.default_app_image_tag}" : var.container_image
}

module "ecr_repository" {
  count  = var.container_image == "" ? 1 : 0
  source = "../ecr_repository"

  service_name = var.service_name
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


  dynamic "volume" {
    for_each = var.efs_volumes
    content {
      name                = volume.value.volume_name
      configure_at_launch = false

      efs_volume_configuration {
        file_system_id     = volume.value.file_system_id
        root_directory     = volume.value.file_system_root
        transit_encryption = "ENABLED"
      }
    }
  }

  container_definitions = jsonencode([{
    name   = var.service_name
    image  = local.container_image
    cpu    = var.service_cpu
    memory = var.service_mem

    essential = true

    portMappings = [{
      name          = var.service_name
      containerPort = var.service_port
      hostPort      = var.service_port
      protocol      = var.protocol
      appProtocol   = var.service_protocol
    }]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.main.id
        awslogs-region        = data.aws_region.current.region
        awslogs-stream-prefix = var.service_name
      }
    }

    mountPoints = [
      for volume in var.efs_volumes : {
        sourceVolume  = volume.volume_name
        containerPath = volume.mount_point
        readOnly      = volume.read_only
      }
    ]

    systemControls = []
    volumesFrom    = []

    environment = var.environment_variables
    secrets     = var.secrets
  }])

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-taskdef"
  })
}
