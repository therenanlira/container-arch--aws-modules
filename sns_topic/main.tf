# SNS

resource "aws_sns_topic" "main" {
  name = "${local.name_prefix}-${var.topic_suffix}"

  tags = {
    Name = "${local.name_prefix}-${var.topic_suffix}"
  }
}

resource "aws_sns_topic_subscription" "main" {
  count = var.create_subscription ? 1 : 0

  topic_arn            = aws_sns_topic.main.arn
  protocol             = "sqs"
  endpoint             = var.queue_arn
  raw_message_delivery = var.raw_message_delivery
}
