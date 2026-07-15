# General

variable "network_values" {
  description = "A map containing the network configuration for the ECS service, including VPC and subnet information."
  type = object({
    vpc_id             = string
    private_subnet_ids = object({})
  })
}

variable "cluster_name" {
  description = "The ARN of the ECS cluster where the service will be deployed."
  type        = string
}

variable "service_name" {
  description = "The name of the ECS service."
  type        = string
}

variable "service_port" {
  description = "The port on which the service will listen."
  type        = number
}

variable "service_cpu" {
  description = "The number of CPU units to reserve for the service."
  type        = number
}

variable "service_mem" {
  description = "The amount of memory (in MiB) to reserve for the service."
  type        = number
}
