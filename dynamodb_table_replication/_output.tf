# Variables

output "global_table_arn" {
  value = var.global_table_arn
}

output "arn" {
  value = aws_dynamodb_table_replica.main.arn
}
