# General

variable "service_name" {
  description = "The name of the ECS service."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'staging', 'prod')."
  type        = string
}
