# Route 53 - Domain Name

resource "aws_api_gateway_domain_name" "main" {
  count = var.dns_name != null && var.certificate_arn != null ? 1 : 0

  regional_certificate_arn = var.certificate_arn
  domain_name              = var.dns_name

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "main" {
  count = var.dns_name != null && var.base_mapping != null ? 1 : 0

  api_id      = aws_api_gateway_rest_api.main.id
  stage_name  = aws_api_gateway_stage.main.stage_name
  domain_name = aws_api_gateway_domain_name.main[0].domain_name
  base_path   = var.base_mapping
}
