locals {
  name_prefix        = "${var.environment}--${var.project_name}--${var.service_name}-"
  global_name_prefix = "${terraform.workspace}--${var.project_name}--${var.service_name}-"

  topic_name = "${local.name_prefix}-${lookup(var.processing_config, "queue_suffix", "sns")}"

  publisher_regions = length(var.publisher_regions) > 0 ? var.publisher_regions : [data.aws_region.current.region]

  publisher_arns = [
    for region in local.publisher_regions :
    "arn:aws:sns:${region}:${data.aws_caller_identity.current.account_id}:${local.topic_name}"
  ]
}
