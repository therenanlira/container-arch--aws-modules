# Route 53 Record

resource "aws_route53_record" "main" {
  count   = var.enable_lb && var.dns_zone_id != "" && var.dns_weight == null ? 1 : 0
  zone_id = var.dns_zone_id
  name    = "${var.service_name}.${var.dns_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "weighted" {
  count   = var.enable_lb && var.dns_zone_id != "" && var.dns_weight != null ? 1 : 0
  zone_id = var.dns_zone_id
  name    = "${var.service_name}.${var.dns_name}"
  type    = "A"

  set_identifier = data.aws_region.current.region

  weighted_routing_policy {
    weight = var.dns_weight
  }

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
