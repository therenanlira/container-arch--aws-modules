# SQS

resource "aws_sqs_queue" "dlq" {
  name = "${local.name_prefix}-${lookup(var.processing_config, "queue_suffix", "dlq")}-dlq"

  delay_seconds              = lookup(var.processing_config, "delay_seconds")
  max_message_size           = lookup(var.processing_config, "max_message_size")
  message_retention_seconds  = lookup(var.processing_config, "message_retention_seconds")
  receive_wait_time_seconds  = lookup(var.processing_config, "receive_wait_time_seconds")
  visibility_timeout_seconds = lookup(var.processing_config, "visibility_timeout_seconds")
}

resource "aws_sqs_queue" "main" {
  name = "${local.name_prefix}-${lookup(var.processing_config, "queue_suffix", "sqs")}"

  delay_seconds              = lookup(var.processing_config, "delay_seconds")
  max_message_size           = lookup(var.processing_config, "max_message_size")
  message_retention_seconds  = lookup(var.processing_config, "message_retention_seconds")
  receive_wait_time_seconds  = lookup(var.processing_config, "receive_wait_time_seconds")
  visibility_timeout_seconds = lookup(var.processing_config, "visibility_timeout_seconds")

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = lookup(var.processing_config, "dlq_redrive_max_receive_count")
  })

  depends_on = [
    aws_sqs_queue.dlq
  ]
}

# IAM

resource "aws_sqs_queue_policy" "main" {
  queue_url = aws_sqs_queue.main.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action = [
          "sqs:SendMessage"
        ]
        Resource = aws_sqs_queue.main.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = local.publisher_arns
          }
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}
