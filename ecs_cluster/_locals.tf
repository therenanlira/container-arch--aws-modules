locals {
  name_prefix        = "${var.environment}--${var.project_name}-"
  global_name_prefix = "${terraform.workspace}--${var.project_name}-"

  ec2_capacity_providers     = [for cp in var.capacity_provider_strategies : cp if contains(["ON_DEMAND", "SPOT"], cp)]
  fargate_capacity_providers = [for cp in var.capacity_provider_strategies : cp if contains(["FARGATE", "FARGATE_SPOT"], cp)]

  asg_tags = {
    Project     = var.project_name
    Region      = data.aws_region.current.region
    Environment = var.environment
    Workspace   = terraform.workspace
    ManagedBy   = "Terraform"
  }
}
