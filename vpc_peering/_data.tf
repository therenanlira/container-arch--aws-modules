data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_region" "central" {
  provider = aws.central
}
