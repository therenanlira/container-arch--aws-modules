# API Gateway

resource "aws_api_gateway_rest_api" "main" {
  name = "${local.name_prefix}-apigw"

  body = var.body_file

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id

  triggers = {
    redeploy = sha256(aws_api_gateway_rest_api.main.body)
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "main" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
  stage_name    = terraform.workspace

  dynamic "access_log_settings" {
    for_each = var.enable_log ? [1] : []
    content {
      destination_arn = aws_cloudwatch_log_group.main[0].arn
      format = jsonencode({
        requestId         = "$context.requestId",
        ip                = "$context.identity. sourceIp",
        caller            = "$context.identity. caller",
        user              = "$context.identity. user",
        requestTime       = "seontext.requestTime",
        httpMethod        = "$context.httpMethod",
        resourcePath      = "$context.resourcePath",
        status            = "$context.status"
        protocol          = "$context.protocol",
        responseLength    = "$context.responseLength"
        responseTime      = "$context.responseLatency",
        responseBody      = "$context.responseBody",
        integrationStatus = "$context.integrationStatus",
        errorMessage      = "$context.error.message",
        errortype         = "$context.error.responseType"
      })
    }
  }
}

resource "aws_api_gateway_method_settings" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = aws_api_gateway_stage.main.stage_name

  method_path = "*/*"

  settings {
    throttling_rate_limit  = 1
    throttling_burst_limit = 1

    # Metrics
    logging_level      = var.enable_log ? "INFO" : null
    metrics_enabled    = var.enable_log ? true : false
    data_trace_enabled = var.enable_log ? true : false
  }
}
