# ECS IAM Role

resource "aws_iam_role" "ecs_role" {
  name = substr("${local.global_name_prefix}-ecs-role", 0, 63)

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
    Name = substr("${local.global_name_prefix}-ecs-role", 0, 63)
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
  name = substr("${local.global_name_prefix}-instance-profile", 0, 63)
  role = aws_iam_role.ecs_role.name

  tags = {
    Name = substr("${local.global_name_prefix}-instance-profile", 0, 63)
  }
}
