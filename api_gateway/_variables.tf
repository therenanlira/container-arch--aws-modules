# General

variable "project_name" {
  description = "The name of the project, used for tagging and naming resources."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'staging', 'prod')."
  type        = string
}

variable "service_name" {
  description = "The name of the ECS service."
  type        = string
}

# API Gateway

variable "body_file" {
  description = "Body file with the API Gateway methods"
  type        = string
}

variable "api_key_names" {
  description = "API Gateway Key names"
  type        = list(string)
  default     = []
}

# Cloudwatch logs

variable "enable_log" {
  description = "Enable or not the Cloudwatch Log Group"
  type        = bool
  default     = true
}

# DNS

variable "dns_name" {
  description = "Route 53 DNS Name"
  type        = string
  default     = null
  validation {
    condition = var.dns_name != null || alltrue([
      var.route53_zone_id == null,
      var.certificate_arn == null,
      var.base_mapping == null,
    ])
    error_message = "dns_name is required when route53_zone_id, certificate_arn or base_mapping is set."
  }
}

variable "route53_zone_id" {
  description = "Route 53 Zone ID"
  type        = string
  default     = null
}

variable "certificate_arn" {
  description = "The DNS Name certification ARN"
  type        = string
  default     = null
}

variable "base_mapping" {
  description = "Base mapping versions"
  type        = string
  default     = null
}
