locals {
  name_prefix        = "${var.environment}--${var.project_name}--${var.service_name}-"
  global_name_prefix = "${terraform.workspace}--${var.project_name}--${var.service_name}-"

  source_name = "${var.environment}-${var.source_bucket.region}"

  destination_buckets = {
    for region in var.destination_regions :
    region => "${data.aws_caller_identity.current.account_id}-${substr(trimsuffix("${var.environment}-${region}--${var.project_name}--${var.service_name}-", "-"), 0, 52)}"
  }

  destination_arns = [for bucket in local.destination_buckets : "arn:aws:s3:::${bucket}"]
}
