# DynamoDB

resource "aws_dynamodb_table_replica" "main" {
  global_table_arn = var.global_table_arn
}
