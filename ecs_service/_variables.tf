# General

variable "network_values" {
  description = "The network configuration values, including VPC and subnets."
  type = object({
    vpc_id             = string
    private_subnet_ids = map(string)
  })
}

variable "project_name" {
  description = "The name of the project, used for tagging and naming resources."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'staging', 'prod')."
  type        = string
}

variable "cluster_name" {
  description = "The ARN of the ECS cluster where the service will be deployed."
  type        = string
}

# DNS

variable "dns_zone_id" {
  description = "The DNS Zone ID value."
  type        = string
  default     = ""
}

variable "dns_name" {
  description = "The DNS Name value."
  type        = string
  default     = ""
}

# Service Discovery

variable "service_discovery_namespace" {
  description = "The Service Discovery Namespace"
  type        = string
  default     = null
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
  type = list(object({
    capacity_provider = string
    weight            = number
  }))
  default = [{
    capacity_provider = "FARGATE_SPOT"
    weight            = 100
  }]
}

variable "service_hosts" {
  description = "List of hosts to be used in ECS Service"
  type        = list(string)
}

variable "enable_service_connect" {
  description = "Enable or not the use of Service Connect"
  type        = bool
  default     = false
}

variable "service_connect_name" {
  description = "Service Connect Name"
  type        = string
  default     = null
}

variable "service_connect_arn" {
  description = "Service Connect ARN"
  type        = string
  default     = null
}

variable "service_protocol" {
  description = "Service protocol. Example: http, https, grpc ou tcp."
  type        = string
  default     = null
}

variable "protocol" {
  description = "Comunication protocol. Example: udp ou tcp."
  type        = string
  default     = "tcp"
}

# Load Balancer

variable "enable_lb" {
  description = "Enable or not the use of Load Balancer"
  type        = bool
  default     = true
}

variable "force_delete" {
  description = "Delete the ECS service without waiting for its tasks to drain. Speeds up destroy in disposable environments."
  type        = bool
  default     = false
}

variable "deregistration_delay" {
  description = "How long the load balancer waits before deregistering a target, in seconds. AWS defaults to 300."
  type        = number
  default     = 0
}

variable "service_listener" {
  description = "The Load Balancer Listener to be forwarded for"
  type        = string
  default     = ""
  validation {
    condition     = !var.enable_lb || var.service_listener != ""
    error_message = "enable_lb = true requires service_listener with the ARN of the load balancer listener the rule is attached to."
  }
}

# Autoscaling

variable "alb_arn" {
  description = "ECS Cluster ALB ARN"
  type        = string
  default     = ""
}

variable "alb_arn_suffix" {
  description = "ECS Cluster ALB ARN Suffix"
  type        = string
  default     = ""
}

variable "alb_dns_name" {
  description = "ECS Cluster ALB DNS Name"
  type        = string
  default     = ""
}

variable "alb_zone_id" {
  description = "ECS Cluster ALB Zone ID"
  type        = string
  default     = ""
}

variable "scale_type" {
  description = "Type of the resource to be used on scale"
  type        = string
  validation {
    condition = (
      strcontains(var.scale_type, "") ||
      strcontains(var.scale_type, "cpu") ||
      strcontains(var.scale_type, "cpu-tracking") ||
      strcontains(var.scale_type, "requests-tracking")
    )
    error_message = "The value must be empty string or one of: \"cpu\", \"cpu-tracking\", \"requests-tracking\""
  }
  default = ""
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

variable "task_count" {
  description = "The amount of tasks that will be running"
  type        = number
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

variable "container_image" {
  description = "Container image path. Generally refer to an external registry"
  type        = string
  default     = ""
}

variable "capabilities" {
  description = "A list of acceptable capabilities"
  type        = list(string)
  default     = ["EC2"]
  validation {
    condition     = contains(var.capabilities, "EC2")
    error_message = "The list must contains one or all of these values: [\"EC2\"]"
  }
}

variable "environment_variables" {
  description = "A list of map containing the environemnt variables"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "secrets" {
  description = "A list of map containing the secrets coming from SSM Parameter Store or Secrets Manager"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

# EFS

variable "efs_volumes" {
  description = "A list with the EFS Arn volumes to be attached to the ECS Services"
  type = list(object({
    volume_name      = string
    file_system_id   = string
    file_system_root = string
    mount_point      = string
    read_only        = bool
  }))
  default = []
}

# Deployment

variable "deployment_controller" {
  description = "The Deployment Controler. Example: 'ECS' or 'CODE_DEPLOY'"
  type        = string
  default     = "ECS"
  nullable    = false
  validation {
    condition     = contains(["ECS", "CODE_DEPLOY"], var.deployment_controller)
    error_message = "The value must be one of: [\"ECS\", \"CODE_DEPLOY\"]"
  }
}

variable "ecs_deployment_type" {
  description = "The ECS native deployment strategy. 'ROLLING' replaces the running tasks in place, 'BLUE_GREEN' starts a whole new revision and shifts the traffic to it. Only used with the 'ECS' deployment controller."
  type        = string
  default     = "ROLLING"
  nullable    = false
  validation {
    condition     = contains(["ROLLING", "BLUE_GREEN"], var.ecs_deployment_type)
    error_message = "The value must be one of: [\"ROLLING\", \"BLUE_GREEN\"]"
  }
  validation {
    condition     = var.ecs_deployment_type != "BLUE_GREEN" || var.deployment_controller == "ECS"
    error_message = "BLUE_GREEN is the native ECS strategy and requires deployment_controller = \"ECS\". CodeDeploy has its own blue/green settings."
  }
}

variable "ecs_bake_time_in_minutes" {
  description = "How long the blue (old) and green (new) revisions stay up after the traffic is shifted, before ECS terminates the blue one. A rollback during this window is immediate."
  type        = number
  default     = 5
}

variable "codedeploy_strategy" {
  description = "The Code Deploy Strategy. Example: 'CodeDeployDefault.AllAtOnce'"
  type        = string
  default     = "CodeDeployDefault.ECSAllAtOnce"
}

variable "codedeploy_deployment_option" {
  description = "The Code Deploy deployment options. Example: 'WITH_TRAFFIC_CONTROL'"
  type        = string
  default     = "WITH_TRAFFIC_CONTROL"
}

variable "codedeploy_deployment_type" {
  description = "The Code Deploy deployment type. Example: 'BLUE_GREEN'"
  type        = string
  default     = "BLUE_GREEN"
}

variable "codedeploy_deployment_termination" {
  description = "The Code Deploy deployment termination wait time in minutes. Example: '5'"
  type        = number
  default     = 5
}

variable "enable_codedeploy_rollback" {
  description = "Enable or not the Code Deploy automatic rollback"
  type        = bool
  default     = true
}

variable "codedeploy_rollback_threshold" {
  description = "The Code Deploy alarm threshold"
  type        = number
  default     = 10
}

variable "codedeploy_rollback_period" {
  description = "The Code Deploy alarm period"
  type        = number
  default     = 60
}

variable "codedeploy_rollback_error_evaluation_period" {
  description = "The Code Deploy alarm error evaluation period"
  type        = number
  default     = 1
}
