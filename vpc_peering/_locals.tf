locals {
  service_name = "${terraform.workspace} <> ${var.environment}-${var.target_region}"
}
