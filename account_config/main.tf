resource "aws_iam_role" "api_gateway_logging" {
  count = var.api_gateway_logging ? 1 : 0

  name = "${local.global_name_prefix}-apigw-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${local.global_name_prefix}-apigw-role"
  })
}

resource "aws_iam_role_policy_attachment" "api_gateway_logging" {
  count = var.api_gateway_logging ? 1 : 0

  role       = aws_iam_role.api_gateway_logging[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_api_gateway_account" "api_gateway_logging" {
  count = var.api_gateway_logging ? 1 : 0

  cloudwatch_role_arn = aws_iam_role.api_gateway_logging[count.index].arn
}
