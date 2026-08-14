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

variable "create_topic" {
  description = "Whether to create the topic. Set to false to only subscribe queues to an existing topic, passed in topic_arn."
  type        = bool
  default     = true
}

variable "topic_arn" {
  description = "ARN of an existing topic to subscribe the queues to. Required when create_topic is false."
  type        = string
  default     = null
  validation {
    condition     = var.create_topic || var.topic_arn != null
    error_message = "create_topic = false requires topic_arn."
  }
}

variable "sqs_arn" {
  description = "Queues subscribed to the topic, keyed by a stable label such as the region. Keys must be known at plan time; the ARNs may be in other regions."
  type        = map(string)
  default     = {}
}

variable "raw_message_delivery" {
  description = "Deliver the message body without the SNS envelope."
  type        = bool
  default     = true
}
