# Variables

output "topic_suffix" {
  value = var.topic_suffix
}

output "queue_arn" {
  value = var.queue_arn
}

output "project_name" {
  value = var.project_name
}

output "service_name" {
  value = var.service_name
}

output "environment" {
  value = var.environment
}

output "create_subscription" {
  value = var.create_subscription
}

output "raw_message_delivery" {
  value = var.raw_message_delivery
}

# SNS

output "arn" {
  value = aws_sns_topic.main.arn
}

output "name" {
  value = aws_sns_topic.main.name
}
