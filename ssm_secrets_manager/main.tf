resource "aws_secretsmanager_secret" "main" {
  name = local.service_name

  tags = {
    Name = local.service_name
  }
}

resource "aws_secretsmanager_secret_version" "main" {
  secret_id     = aws_secretsmanager_secret.main.id
  secret_string = var.value
}
