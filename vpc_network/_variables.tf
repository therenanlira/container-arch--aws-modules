# General

variable "project_name" {
  description = "The name of the project, used for tagging and naming resources."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'staging', 'prod')."
  type        = string
}

# Network

variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "subnet_count" {
  description = "The number of subnets to create in the VPC."
  type        = number
  default     = 3
}

variable "vpce_gateways" {
  description = "A list of AWS services for which to create VPC endpoints (e.g., 's3', 'dynamodb')."
  type        = list(string)
  default     = ["s3", "dynamodb"]
}
