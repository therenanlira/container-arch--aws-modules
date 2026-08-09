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
          "logs:PutLogEvents",
          "ssm:GetParameters",
          "secretsmanager:GetSecretValue"
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

# Code Deploy

resource "aws_iam_role" "ecs_codedeploy_role" {
  count = strcontains(var.deployment_controller, "CODE_DEPLOY") ? 1 : 0

  name = substr("${local.name_prefix}-cdp-er", 0, 64)

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(local.tags, {
    Name = substr("${local.name_prefix}-cdp-er", 0, 64)
  })
}

resource "aws_iam_role_policy_attachment" "ecs_codedeploy_role" {
  count = strcontains(var.deployment_controller, "CODE_DEPLOY") ? 1 : 0

  role       = aws_iam_role.ecs_codedeploy_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

resource "aws_iam_role" "ecs_blue_green_role" {
  count = var.enable_lb && local.ecs_blue_green ? 1 : 0

  name = "${substr("${local.name_prefix}", 0, 58)}-bg-er"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(local.tags, {
    Name = "${substr("${local.name_prefix}", 0, 58)}-bg-er"
  })
}

resource "aws_iam_role_policy_attachment" "ecs_blue_green_role" {
  count = var.enable_lb && local.ecs_blue_green ? 1 : 0

  role       = aws_iam_role.ecs_blue_green_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECSInfrastructureRolePolicyForLoadBalancers"
}
