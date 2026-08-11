# EC2 IAM Role

resource "aws_iam_role" "ec2" {
  name = "${substr(local.global_name_prefix, 0, 59)}-role"

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

  tags = merge(local.tags, {
    Name = "${substr(local.global_name_prefix, 0, 59)}-role"
  })
}

resource "aws_iam_role_policy_attachment" "ssm_role" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "these" {
  for_each = toset(var.iam_policy_arns)

  role       = aws_iam_role.ec2.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${substr(local.global_name_prefix, 0, 59)}-ec2p"
  role = aws_iam_role.ec2.name

  tags = merge(local.tags, {
    Name = "${substr(local.global_name_prefix, 0, 59)}-ec2p"
  })
}
