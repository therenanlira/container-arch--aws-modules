locals {
  name_prefix        = "${var.environment}--${var.project_name}-"
  global_name_prefix = "${terraform.workspace}--${var.project_name}-"

  # Graviton instance types carry a "g" right after the generation number (t4g, m7g, c7gn).
  ami_architecture = coalesce(var.ami_architecture, can(regex("^[a-z]+[0-9]+g[a-z]*\\.", var.instance_type)) ? "arm64" : "x86_64")

  subnet_ids = var.subnet_placement == "public" ? var.network_values.public_subnet_ids : var.network_values.private_subnet_ids
  subnet_id  = values(local.subnet_ids)[0]

  associate_public_ip_address = var.associate_public_ip_address != null ? var.associate_public_ip_address : var.subnet_placement == "public"

  tags = {
    Service = var.service_name
  }
}
