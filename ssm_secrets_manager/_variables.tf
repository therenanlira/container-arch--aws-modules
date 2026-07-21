# General

variable "service_name" {
  description = "The name of the SSM Secret"
  type        = string
}

variable "value" {
  description = "The value of the SSM Secret"
  type        = string
}
