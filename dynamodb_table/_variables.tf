# General

variable "project_name" {
  description = "The name of the project, used for tagging and naming resources."
  type        = string
}

variable "service_name" {
  description = "The name of the ECS service."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'staging', 'prod')."
  type        = string
}

# DynamoDB

variable "dynamodb_values" {
  description = "DynamoDB values"
  type = object({
    table_suffix              = optional(string)
    billing_mode              = string
    point_in_time_recovery    = bool
    recovery_period_in_days   = number
    read_min                  = number
    read_max                  = number
    read_autoscale_threshold  = number
    write_min                 = number
    write_max                 = number
    write_autoscale_threshold = number
  })
  default = null
}
