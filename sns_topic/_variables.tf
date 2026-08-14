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

# SNS

variable "topic_suffix" {
  description = "Suffix of the topic name. Must match the queue_suffix of the target queue, since the queue policy allows publishers by name."
  type        = string
  default     = "sns"
}

variable "queue_arn" {
  description = "ARN of the SQS queue subscribed to the topic. May be in another region."
  type        = string
  default     = null
  validation {
    condition     = !var.create_subscription || var.queue_arn != null
    error_message = "create_subscription = true requires queue_arn."
  }
}

variable "create_subscription" {
  description = "Whether to subscribe the queue to the topic."
  type        = bool
  default     = true
}

variable "raw_message_delivery" {
  description = "Deliver the message body without the SNS envelope."
  type        = bool
  default     = true
}
