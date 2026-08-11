locals {
  service_name        = "${var.environment}--${var.service_name}"
  global_service_name = "${terraform.workspace}--${var.service_name}"
}
