# General

variable "project_name" {
  description = "The name of the project, used for tagging and naming resources."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'staging', 'prod')."
  type        = string
}

variable "network_values" {
  description = "The network configuration for the ECS cluster, including VPC and subnets."
  type = object({
    vpc_id             = string
    vpc_cidr_block     = string
    private_subnet_ids = map(string)
    public_subnet_ids  = map(string)
  })
}

# ECS Cluster

variable "capacity_provider_strategies" {
  description = "A list of capacity provider strategies to use for the ECS cluster."
  type        = list(string)
  default     = ["ON_DEMAND", "SPOT"]
  validation {
    condition = (
      contains(var.capacity_provider_strategies, "ON_DEMAND") ||
      contains(var.capacity_provider_strategies, "SPOT") ||
      contains(var.capacity_provider_strategies, "FARGATE") ||
      contains(var.capacity_provider_strategies, "FARGATE_SPOT")
    )
    error_message = "The value must be a list containing one or more of the values: [\"ON_DEMAND\", \"SPOT\", \"FARGATE\", \"FARGATE_SPOT\"]"
  }
}

variable "ecs_autoscaling" {
  description = "A map of autoscaling configurations for each capacity provider strategy."
  type = map(object({
    minimum = string
    maximum = string
    desired = string
  }))
}

variable "ecs_ami" {
  description = "The AMI ID to use for the ECS instances."
  type        = string
}

variable "ecs_instance_type" {
  description = "The instance type to use for the ECS instances."
  type        = string
}

variable "ecs_volume_size" {
  description = "The size of the EBS volume to attach to each ECS instance (in GB)."
  type        = string
}

variable "ecs_volume_type" {
  description = "The type of the EBS volume to attach to each ECS instance (e.g., 'gp2', 'gp3')."
  type        = string
}

# Load Balancer

variable "load_balancer_internal" {
  description = "Whether the load balancer should be internal (true) or internet-facing (false)."
  type        = bool
}

variable "load_balancer_type" {
  description = "The type of load balancer to create (e.g., 'application', 'network')."
  type        = string
}


# Launch Template

variable "user_data_template" {
  description = "The user data template for the ECS instances."
  type        = string
}
