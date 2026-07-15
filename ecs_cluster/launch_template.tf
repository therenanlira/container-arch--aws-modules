# Launch Template

resource "aws_launch_template" "these" {
  for_each = toset(var.capacity_provider_strategies)

  name_prefix = "${local.name_prefix}-${replace(each.value, "_", "-")}--lt"

  image_id               = var.ecs_ami
  instance_type          = var.ecs_instance_type
  update_default_version = true

  vpc_security_group_ids = [
    aws_security_group.ecs_cluster.id
  ]

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_role.name
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.ecs_volume_size
      volume_type = var.ecs_volume_type
    }
  }

  dynamic "instance_market_options" {
    for_each = contains(toset(var.capacity_provider_strategies), "spot") ? [0] : []
    content {
      market_type = "spot"
      spot_options {
        max_price = "0.15"
      }
    }
  }

  user_data = base64encode(templatefile(var.user_data_template, {
    ECS_CLUSTER = aws_ecs_cluster.main.name
  }))

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.tags, {
      Name = "${local.name_prefix}-${replace(each.value, "_", "-")}--lt"
    })
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-${replace(each.value, "_", "-")}--lt"
  })
}
