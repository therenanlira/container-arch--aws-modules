locals {
  region       = data.aws_region.current.region
  service_name = "/${terraform.workspace}/${local.region}/${var.service_name}"

  tags = {
    Service = var.service_name
  }
}
