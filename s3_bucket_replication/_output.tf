# Variables

output "project_name" {
  value = var.project_name
}

output "service_name" {
  value = var.service_name
}

output "environment" {
  value = var.environment
}

output "source_bucket" {
  value = var.source_bucket.bucket
}

output "source_region" {
  value = var.source_bucket.region
}

output "destination_regions" {
  value = var.destination_regions
}

output "replica_modification_sync" {
  value = var.replica_modification_sync
}

output "delete_marker_replication" {
  value = var.delete_marker_replication
}

output "storage_class" {
  value = var.storage_class
}

# Replication

output "destination_buckets" {
  value = local.destination_buckets
}

output "role_arn" {
  value = aws_iam_role.replication.arn
}
