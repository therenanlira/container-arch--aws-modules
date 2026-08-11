# General

variable "listener_arn" {
  description = "The ARN of the Global Accelerator listener this endpoint group belongs to."
  type        = string
}

variable "endpoint_group_region" {
  description = "The region of the endpoints registered in this group."
  type        = string
}

# Endpoints

variable "endpoints" {
  description = "The endpoints of the region (ALB/NLB ARNs, Elastic IP allocation IDs or EC2 instance IDs) and how traffic is split between them."
  type = list(object({
    endpoint_id                    = string
    weight                         = optional(number, 100)
    client_ip_preservation_enabled = optional(bool, true)
  }))
}

variable "traffic_dial_percentage" {
  description = "Percentage of the traffic directed to this region. Lowering it shifts traffic to the other regions of the listener."
  type        = number
  default     = 100
  validation {
    condition     = var.traffic_dial_percentage >= 0 && var.traffic_dial_percentage <= 100
    error_message = "The value must be between 0 and 100."
  }
}

# Health Check

variable "health_check_protocol" {
  description = "The protocol Global Accelerator uses to health check the endpoints ('TCP', 'HTTP' or 'HTTPS')."
  type        = string
  default     = "HTTP"
  validation {
    condition     = contains(["TCP", "HTTP", "HTTPS"], var.health_check_protocol)
    error_message = "The value must be one of: [\"TCP\", \"HTTP\", \"HTTPS\"]"
  }
}

variable "health_check_path" {
  description = "The path of the health check, when the protocol is HTTP or HTTPS."
  type        = string
  default     = "/"
}

variable "health_check_port" {
  description = "The port of the health check. When null, it follows the listener port of the endpoint."
  type        = number
  default     = null
}

variable "health_check_interval_seconds" {
  description = "How often the endpoints are health checked, in seconds (10 or 30)."
  type        = number
  default     = 30
  validation {
    condition     = contains([10, 30], var.health_check_interval_seconds)
    error_message = "The value must be one of: [10, 30]"
  }
}

variable "threshold_count" {
  description = "Consecutive health checks required to change the endpoint state."
  type        = number
  default     = 3
}
