# API Gateway Key

resource "aws_api_gateway_api_key" "these" {
  for_each = toset(var.api_key_names)

  name    = each.value
  enabled = true
}

resource "aws_api_gateway_usage_plan" "these" {
  for_each = toset(var.api_key_names)

  name = "Usage Plan for: ${each.value}"

  throttle_settings {
    burst_limit = 10
    rate_limit  = 1
  }

  quota_settings {
    limit  = 100000
    period = "MONTH"
  }

  api_stages {
    api_id = aws_api_gateway_rest_api.main.id
    stage  = aws_api_gateway_stage.main.stage_name
  }
}

resource "aws_api_gateway_usage_plan_key" "these" {
  for_each = toset(var.api_key_names)

  key_id        = aws_api_gateway_api_key.these[each.key].id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.these[each.key].id
}
