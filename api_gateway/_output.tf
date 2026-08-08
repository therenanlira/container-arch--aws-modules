# Variables

output "project_name" {
  value = var.project_name
}

output "body_file" {
  value = var.body_file
}

output "invoke_url" {
  value = aws_api_gateway_stage.main.invoke_url
}
