# General

variable "service_name" {
  description = "The name of the ECS service."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'staging', 'prod')."
  type        = string
}

# Global Accelerator

variable "enabled" {
  description = "Whether the accelerator accepts and routes traffic."
  type        = bool
  default     = true
}

variable "ip_address_type" {
  description = "The IP address type of the accelerator ('IPV4' or 'DUAL_STACK')."
  type        = string
  default     = "IPV4"
  validation {
    condition     = contains(["IPV4", "DUAL_STACK"], var.ip_address_type)
    error_message = "The value must be one of: [\"IPV4\", \"DUAL_STACK\"]"
  }
}

# Listener

variable "listener_protocol" {
  description = "The protocol of the listener ('TCP' or 'UDP')."
  type        = string
  default     = "TCP"
  validation {
    condition     = contains(["TCP", "UDP"], var.listener_protocol)
    error_message = "The value must be one of: [\"TCP\", \"UDP\"]"
  }
}

variable "listener_ports" {
  description = "The port ranges the listener accepts traffic on."
  type = list(object({
    from_port = number
    to_port   = number
  }))
  default = [{
    from_port = 80
    to_port   = 80
  }]
}

variable "client_affinity" {
  description = "How the accelerator keeps a client on the same endpoint. 'NONE' spreads by 5-tuple, 'SOURCE_IP' pins by source address."
  type        = string
  default     = "SOURCE_IP"
  validation {
    condition     = contains(["NONE", "SOURCE_IP"], var.client_affinity)
    error_message = "The value must be one of: [\"NONE\", \"SOURCE_IP\"]"
  }
}
