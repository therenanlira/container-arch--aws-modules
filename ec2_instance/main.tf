# EC2 Instance

resource "aws_instance" "main" {
  ami           = coalesce(var.ami, data.aws_ami.amazon_linux.id)
  instance_type = var.instance_type

  subnet_id                   = local.subnet_id
  associate_public_ip_address = local.associate_public_ip_address

  vpc_security_group_ids = [
    aws_security_group.ec2.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2.name
  key_name             = var.key_name

  user_data                   = var.user_data
  user_data_replace_on_change = true

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
    encrypted   = true

    tags = merge(local.tags, {
      Name = "${local.name_prefix}-root"
    })
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-ec2"
  })
}
