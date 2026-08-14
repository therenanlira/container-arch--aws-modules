# General

variable "project_name" {
  description = "The name of the project, used for tagging and naming resources."
  type        = string
  default     = null
}

variable "service_name" {
  description = "The name of the ECS service."
  type        = string
  default     = null
}

variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'staging', 'prod')."
  type        = string
  default     = null
}

# SQS

variable "processing_config" {
  description = "Processing configurations"
  type = object({
    queue_suffix                  = string
    delay_seconds                 = number
    max_message_size              = number
    message_retention_seconds     = number
    receive_wait_time_seconds     = number
    visibility_timeout_seconds    = number
    dlq_redrive_max_receive_count = number
  })
}

variable "publisher_regions" {
  description = "Regions whose SNS topics may publish to this queue. Empty means only the region of the queue."
  type        = list(string)
  default     = []
}
