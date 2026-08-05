locals {
  name_prefix = "${terraform.workspace}--${var.service_name}-"

  target_group_name = replace(substr("${local.name_prefix}-alb-tg", 0, 32), "/-+$/", "")

  target_group_arn        = one(aws_alb_target_group.main[*].arn)
  target_group_arn_suffix = one(aws_alb_target_group.main[*].arn_suffix)

  tags = {
    Service = var.service_name
  }
}
