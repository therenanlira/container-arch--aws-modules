data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_alb" "main" {
  count = var.enable_lb ? 1 : 0
  arn   = var.alb_arn
}
