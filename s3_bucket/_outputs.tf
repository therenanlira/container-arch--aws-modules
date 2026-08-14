# Variables

output "bucket" {
  value = aws_s3_bucket.bucket.id
}

output "region" {
  value = data.aws_region.current.region
}

output "put_object_policy_arn" {
  value = aws_iam_policy.put_object_policy.arn
}

output "get_object_policy_arn" {
  value = aws_iam_policy.get_object_policy.arn
}

output "delete_object_policy_arn" {
  value = aws_iam_policy.delete_object_policy.arn
}

output "list_object_policy_arn" {
  value = aws_iam_policy.list_object_policy.arn
}
