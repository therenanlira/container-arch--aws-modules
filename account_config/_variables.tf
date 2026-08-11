# Optional variables
variable "common_tags" {
  description = "A map of tags to assign to all resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'staging', 'prod')."
  type        = string
}

variable "api_gateway_logging" {
  description = "Enable or not the IAM Role for API Gateway Logging"
  type        = bool
  default     = true
}
