# S3 Replication

resource "aws_s3_bucket_replication_configuration" "main" {
  bucket = var.source_bucket.bucket
  role   = aws_iam_role.replication.arn

  dynamic "rule" {
    for_each = var.destination_regions

    content {
      id       = rule.value
      status   = "Enabled"
      priority = index(var.destination_regions, rule.value)

      filter {}

      delete_marker_replication {
        status = var.delete_marker_replication ? "Enabled" : "Disabled"
      }

      source_selection_criteria {
        replica_modifications {
          status = var.replica_modification_sync ? "Enabled" : "Disabled"
        }

      }

      destination {
        bucket        = "arn:aws:s3:::${local.destination_buckets[rule.value]}"
        storage_class = var.storage_class
      }
    }
  }
}
