# General

variable "network_values" {
  description = "The network configuration for the ECS cluster, including VPC and subnets."
  type = object({
    vpc_id             = string
    private_subnet_ids = map(string)
  })
}

variable "project_name" {
  description = "The name of the project, used for tagging and naming resources."
  type        = string
}

variable "cluster_name" {
  description = "The ARN of the ECS cluster where the service will be deployed."
  type        = string
}

# ECS Service

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

variable "service_healthcheck" {
  description = "A map with health check values"
  type        = map(string)
}

variable "service_launch_type" {
  description = "The ECS Service Launch Type"
  type        = string
  validation {
    condition     = strcontains(var.service_launch_type, "EC2")
    error_message = "The acceptable values are: \"EC2\" or \"spot\""
  }
}

variable "service_task_count" {
  description = "The amount of tasks that will be running"
  type        = number
}

variable "service_hosts" {
  description = "List of hosts to be used in ECS Service"
  type        = list(string)
}

variable "service_listener" {
  description = "The Load Balancer Listener to be forwarded for"
  type        = string
}

# Autoscaling

variable "alb_arn" {
  description = "ECS Cluster ALB ARN"
  type        = string
  default     = null
}

variable "scale_type" {
  description = "Type of the resource to be used on scale"
  type        = string
  validation {
    condition = (
      strcontains(var.scale_type, "cpu") ||
      strcontains(var.scale_type, "cpu-tracking") ||
      strcontains(var.scale_type, "requests-tracking")
    )
    error_message = "The value must be one of: \"cpu\", \"cpu-tracking\", \"requests-tracking\""
  }
  default = null
}

variable "scale_tracking_cpu" {
  description = "Scale in and out based on CPU"
  type        = number
  default     = 80
}

variable "scale_tracking_requests" {
  description = "Scale in and out based on requests"
  type        = number
  default     = 0
}

variable "task_min" {
  description = "Minimum tasks"
  type        = number
  default     = 3
}

variable "task_max" {
  description = "Maximum tasks"
  type        = number
  default     = 10
}

variable "scale_out_cpu" {
  description = "Scale out based on CPU"
  type = object({
    threshold           = number
    adjustment          = number
    comparison_operator = string
    statistic           = string
    period              = number
    evaluation_periods  = number
    cooldown            = number
  })
  default = {
    threshold           = 80
    adjustment          = 1
    comparison_operator = "GreaterThanOrEqualToThreshold"
    statistic           = "Average"
    period              = 60
    evaluation_periods  = 2
    cooldown            = 60
  }
}

variable "scale_in_cpu" {
  description = "Scale in based on CPU"
  type = object({
    threshold           = number
    adjustment          = number
    comparison_operator = string
    statistic           = string
    period              = number
    evaluation_periods  = number
    cooldown            = number
  })
  default = {
    threshold           = 30
    adjustment          = -1
    comparison_operator = "LessThanOrEqualToThreshold"
    statistic           = "Average"
    period              = 120
    evaluation_periods  = 3
    cooldown            = 120
  }
}

# Task Definition

variable "capabilities" {
  description = "A list of acceptable capabilities"
  type        = list(string)
  validation {
    condition     = contains(var.capabilities, "EC2")
    error_message = "The list must contains one or all of these values: [\"EC2\"]"
  }
}

variable "environment_variables" {
  description = "A list of map containing the environemnt variables"
  type        = list(map(string))
}
