locals {
  send_policy_statements = [
    {
      Action = [
        "sqs:SendMessage",
        "sqs:GetQueueAttributes",
      ]
      Effect   = "Allow"
      Resource = aws_sqs_queue.main.arn
    },
  ]

  receive_policy_statements = [
    {
      Action = [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:ChangeMessageVisibility",
        "sqs:GetQueueAttributes"
      ]
      Effect   = "Allow"
      Resource = aws_sqs_queue.main.arn
    },
  ]
}

resource "aws_iam_policy" "send_policy" {
  name = "${local.global_name_prefix}-send-policy"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = local.send_policy_statements
  })

  depends_on = [
    aws_sqs_queue.main
  ]
}

resource "aws_iam_policy" "receive_policy" {
  name = "${local.global_name_prefix}-receive-policy"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = local.receive_policy_statements
  })

  depends_on = [
    aws_sqs_queue.main
  ]
}
