# Global Accelerator Endpoint Group

resource "aws_globalaccelerator_endpoint_group" "main" {
  listener_arn          = var.listener_arn
  endpoint_group_region = var.endpoint_group_region

  traffic_dial_percentage = var.traffic_dial_percentage

  health_check_protocol         = var.health_check_protocol
  health_check_path             = var.health_check_protocol == "TCP" ? null : var.health_check_path
  health_check_port             = var.health_check_port
  health_check_interval_seconds = var.health_check_interval_seconds
  threshold_count               = var.threshold_count

  dynamic "endpoint_configuration" {
    for_each = var.endpoints
    content {
      endpoint_id                    = endpoint_configuration.value.endpoint_id
      weight                         = endpoint_configuration.value.weight
      client_ip_preservation_enabled = endpoint_configuration.value.client_ip_preservation_enabled
    }
  }
}
