# Service Execution Role

resource "aws_iam_role" "ecs_service_execution_role" {
  name = substr("${local.name_prefix}-svc-er", 0, 64)

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(local.tags, {
    Name = substr("${local.name_prefix}-svc-er", 0, 64)
  })
}

resource "aws_iam_role_policy" "ecs_service_execution_role" {
  name = substr("${local.name_prefix}-svc-ep", 0, 64)
  role = aws_iam_role.ecs_service_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:Describe*",
          "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
          "elasticloadbalancing:RegisterTargets",
          "ec2:Describe*",
          "ec2:AuthorizeSecurityGroupIngress",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# Task Execution Role

resource "aws_iam_role" "ecs_task_execution_role" {
  name = substr("${local.name_prefix}-tsk-er", 0, 64)

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(local.tags, {
    Name = substr("${local.name_prefix}-tsk-er", 0, 64)
  })
}

resource "aws_iam_role_policy" "ecs_task_execution_role" {
  name = substr("${local.name_prefix}-tsk-ep", 0, 64)
  role = aws_iam_role.ecs_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "s3:GetObject",
          "sqs:*",
        ]
        Resource = "*"
      }
    ]
  })
}

# 

resource "aws_security_group" "ecs_service" {
  name = "${local.name_prefix}-ecs-sg"

  vpc_id = var.network_values.vpc_id

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-ecs-sg"
  })
}

resource "aws_vpc_security_group_egress_rule" "ecs_service_outbound_all" {
  security_group_id = aws_security_group.ecs_service.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-ecs-sg outbound all"
  })
}

resource "aws_vpc_security_group_ingress_rule" "ecs_service_inbound_all_vpc" {
  security_group_id = aws_security_group.ecs_service.id

  from_port   = var.service_port
  to_port     = var.service_port
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-lb-sg inbound http"
  })
}
