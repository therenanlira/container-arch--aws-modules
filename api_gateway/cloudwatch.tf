# Cloudwatch Log Group

resource "aws_cloudwatch_log_group" "main" {
  count = var.enable_log ? 1 : 0

  name              = "${terraform.workspace}/${var.project_name}/${var.service_name}"
  retention_in_days = 1
}
