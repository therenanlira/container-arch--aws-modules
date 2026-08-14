locals {
  name_prefix        = "${var.environment}--${var.project_name}--${var.service_name}-"
  global_name_prefix = "${terraform.workspace}--${var.project_name}--${var.service_name}-"
}
