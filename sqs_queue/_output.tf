# Variables

output "project_name" {
  value = var.project_name
}

output "service_name" {
  value = var.service_name
}

output "environment" {
  value = var.environment
}

output "processing_config" {
  value = var.processing_config
}

output "publisher_regions" {
  value = var.publisher_regions
}

output "arn" {
  value = aws_sqs_queue.main.arn
}

output "dlq_arn" {
  value = aws_sqs_queue.dlq.arn
}

output "send_policy_arn" {
  value = aws_iam_policy.send_policy.arn
}

output "receive_policy_arn" {
  value = aws_iam_policy.receive_policy.arn
}
