# General

variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'staging', 'prod')."
  type        = string
}

# Network

variable "network_values" {
  description = "The network configuration for the ECS cluster, including VPC and subnets."
  type = object({
    vpc_id                  = string
    vpc_cidr_block          = string
    private_subnet_ids      = map(string)
    private_route_table_ids = map(string)
  })
}

variable "target_account_id" {
  description = "The Account ID of the VPC that will accept the peering request"
  type        = string
}

variable "target_vpc_id" {
  description = "The VPC ID that will accept the peering request"
  type        = string
}

variable "target_region" {
  description = "The region of the VPC that will accept the peering request"
  type        = string
}

variable "target_route_table_ids" {
  description = "The Route Table IDs of the VPC that will accept the peering request"
  type        = map(string)
}

variable "target_cidr_block" {
  description = "The CIDR of the VPC that will accept the peering request"
  type        = string
}
