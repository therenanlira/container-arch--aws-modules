locals {
  name_prefix        = "${var.environment}--${var.project_name}--${var.service_name}-"
  global_name_prefix = "${terraform.workspace}--${var.project_name}--${var.service_name}-"
}

locals {
  topic_arn = var.create_topic ? one(aws_sns_topic.main[*].arn) : var.topic_arn
}
