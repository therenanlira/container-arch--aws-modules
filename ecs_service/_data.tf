data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_alb" "main" {
  arn = var.alb_arn
}
