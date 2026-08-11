locals {
  name_prefix        = "${var.environment}--${var.service_name}"
  global_name_prefix = "${terraform.workspace}--${var.service_name}"
}
