# ECS Cluster

resource "aws_ecs_cluster" "main" {
  name = "${local.name_prefix}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  tags = {
    Name = "${local.name_prefix}-ecs-cluster"
  }
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = [
    for cp in aws_ecs_capacity_provider.these : cp.name
  ]

  dynamic "default_capacity_provider_strategy" {
    for_each = contains(toset(var.capacity_provider_strategies), "ON_DEMAND") ? [0] : []
    content {
      capacity_provider = aws_ecs_capacity_provider.these["ON_DEMAND"].name
      weight            = 100
      base              = 0
    }
  }

  dynamic "default_capacity_provider_strategy" {
    for_each = contains(toset(var.capacity_provider_strategies), "FARGATE") ? [0] : []
    content {
      capacity_provider = aws_ecs_capacity_provider.these["FARGATE"].name
      weight            = 100
      base              = 1
    }
  }
}

# ECS Security Group

resource "aws_security_group" "ecs_cluster" {
  name = "${local.name_prefix}-ecs-sg"

  vpc_id = var.network_values.vpc_id

  tags = {
    Name = "${local.name_prefix}-ecs-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "ecs_cluster_outbound_all" {
  security_group_id = aws_security_group.ecs_cluster.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "${local.name_prefix}-ecs-sg outbound all"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ecs_cluster_inbound_all_vpc" {
  security_group_id = aws_security_group.ecs_cluster.id

  ip_protocol = "-1"
  cidr_ipv4   = var.network_values.vpc_cidr_block

  tags = {
    Name = "${local.name_prefix}-ecs-sg inbound all from VPC"
  }
}

# ECS IAM Role

resource "aws_iam_role" "ecs_role" {
  name = substr("${local.name_prefix}-ecs-role", 0, 63)

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = substr("${local.name_prefix}-ecs-role", 0, 63)
  }
}

resource "aws_iam_role_policy_attachment" "ec2_role" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ssm_role" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "ecs_role" {
  name = substr("${local.name_prefix}-instance-profile", 0, 63)
  role = aws_iam_role.ecs_role.name

  tags = {
    Name = substr("${local.name_prefix}-instance-profile", 0, 63)
  }
}
