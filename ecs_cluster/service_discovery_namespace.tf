# Service Discovery

resource "aws_service_discovery_private_dns_namespace" "main" {
  name        = "${terraform.workspace}.${var.project_name}.sd"
  description = "Service Discovery for Cluster ECS ${var.project_name}"
  vpc         = var.network_values.vpc_id

  tags = {
    Name = "${terraform.workspace}.${var.project_name}.sd"
  }
}
