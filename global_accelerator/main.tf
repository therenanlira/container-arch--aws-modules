# Global Accelerator

resource "aws_globalaccelerator_accelerator" "main" {
  name            = "${local.name_prefix}-gax"
  ip_address_type = var.ip_address_type
  enabled         = var.enabled

  tags = {
    Name = "${local.name_prefix}-gax"
  }
}

resource "aws_globalaccelerator_listener" "main" {
  accelerator_arn = aws_globalaccelerator_accelerator.main.id
  client_affinity = var.client_affinity
  protocol        = var.listener_protocol

  dynamic "port_range" {
    for_each = var.listener_ports
    content {
      from_port = port_range.value.from_port
      to_port   = port_range.value.to_port
    }
  }
}
