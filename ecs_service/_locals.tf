locals {
  name_prefix        = "${var.environment}--${var.service_name}-"
  global_name_prefix = "${terraform.workspace}--${var.service_name}-"

  ecs_blue_green = var.deployment_controller == "ECS" && var.ecs_deployment_type == "BLUE_GREEN"

  target_group_keys = local.ecs_blue_green ? ["blue", "green"] : ["rolling"]

  target_group_arn        = try(aws_alb_target_group.main[local.target_group_keys[0]].arn, null)
  target_group_arn_suffix = try(aws_alb_target_group.main[local.target_group_keys[0]].arn_suffix, null)

  tags = {
    Service = var.service_name
  }
}
