# Variables

output "project_name" {
  value = var.project_name
}

output "service_name" {
  value = var.service_name
}

output "network_values" {
  value = var.network_values
}

output "instance_type" {
  value = var.instance_type
}

output "subnet_placement" {
  value = var.subnet_placement
}

output "associate_public_ip_address" {
  value = var.associate_public_ip_address
}

output "key_name" {
  value = var.key_name
}

output "volume_size" {
  value = var.volume_size
}

output "volume_type" {
  value = var.volume_type
}

output "user_data" {
  value = var.user_data
}

output "allowed_ssh_cidrs" {
  value = var.allowed_ssh_cidrs
}

output "iam_policy_arns" {
  value = var.iam_policy_arns
}

output "environment" {
  value = var.environment
}

output "ami_architecture" {
  value = var.ami_architecture
}

# EC2

output "id" {
  value = aws_instance.main.id
}

output "arn" {
  value = aws_instance.main.arn
}

output "ami" {
  value = aws_instance.main.ami
}

output "availability_zone" {
  value = aws_instance.main.availability_zone
}

output "private_ip" {
  value = aws_instance.main.private_ip
}

output "public_ip" {
  value = aws_instance.main.public_ip
}

# Security Group

output "security_group_id" {
  value = aws_security_group.ec2.id
}

# IAM

output "iam_role_name" {
  value = aws_iam_role.ec2.name
}

output "iam_role_arn" {
  value = aws_iam_role.ec2.arn
}

output "iam_instance_profile_name" {
  value = aws_iam_instance_profile.ec2.name
}
