# DynamoDB

resource "aws_dynamodb_table" "main" {
  name = "${local.name_prefix}-${lookup(var.dynamodb_values, "table_suffix", "tbl")}"

  read_capacity  = lookup(var.dynamodb_values, "read_min")
  write_capacity = lookup(var.dynamodb_values, "write_min")

  billing_mode = lookup(var.dynamodb_values, "billing_mode")

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  hash_key = "id"


  attribute {
    name = "id"
    type = "S"
  }

  point_in_time_recovery {
    enabled                 = lookup(var.dynamodb_values, "point_in_time_recovery")
    recovery_period_in_days = lookup(var.dynamodb_values, "recovery_period_in_days")
  }

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity,
      replica
    ]
  }
}

resource "aws_appautoscaling_target" "read" {

  max_capacity = lookup(var.dynamodb_values, "read_max")
  min_capacity = lookup(var.dynamodb_values, "read_min")

  resource_id        = "table/${aws_dynamodb_table.main.id}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_target" "write" {

  max_capacity = lookup(var.dynamodb_values, "write_max")
  min_capacity = lookup(var.dynamodb_values, "write_min")

  resource_id        = "table/${aws_dynamodb_table.main.id}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "read" {
  name = "${local.name_prefix}-read"

  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.read.resource_id
  scalable_dimension = aws_appautoscaling_target.read.scalable_dimension
  service_namespace  = aws_appautoscaling_target.read.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = lookup(var.dynamodb_values, "read_autoscale_threshold")
  }
}

resource "aws_appautoscaling_policy" "write" {
  name = "${local.name_prefix}-write"

  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.write.resource_id
  scalable_dimension = aws_appautoscaling_target.write.scalable_dimension
  service_namespace  = aws_appautoscaling_target.write.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = lookup(var.dynamodb_values, "write_autoscale_threshold")
  }
}
