# SNS

resource "aws_sns_topic" "main" {
  count = var.create_topic ? 1 : 0
  name  = "${local.name_prefix}-${var.topic_suffix}"

  tags = {
    Name = "${local.name_prefix}-${var.topic_suffix}"
  }
}

resource "aws_sns_topic_subscription" "these" {
  for_each = var.sqs_arn

  topic_arn            = local.topic_arn
  protocol             = "sqs"
  endpoint             = each.value
  raw_message_delivery = var.raw_message_delivery
}
