# General

variable "service_name" {
  description = "The name of the EFS service."
  type        = string
}

variable "network_values" {
  description = "The network configuration values, including VPC and subnets."
  type = object({
    vpc_id             = string
    private_subnet_ids = map(string)
  })
}

variable "performance_mode" {
  description = "EFS performance mode"
  type        = string
  default     = "generalPurpose"
}

variable "throughput_mode" {
  description = "EFS throughput mode"
  type        = string
  default     = "bursting"
}
