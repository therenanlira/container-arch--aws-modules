# Variables

output "topic_suffix" {
  value = var.topic_suffix
}

output "sqs_arn" {
  value = var.sqs_arn
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

output "raw_message_delivery" {
  value = var.raw_message_delivery
}

# SNS

output "arn" {
  value = local.topic_arn
}

output "name" {
  value = one(aws_sns_topic.main[*].name)
}

output "create_topic" {
  value = var.create_topic
}
