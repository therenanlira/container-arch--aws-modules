resource "aws_ssm_parameter" "main" {
  name  = local.service_name
  type  = "String"
  value = var.value

  tags = {
    Name = local.service_name
  }
}
