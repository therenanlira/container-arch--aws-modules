# CloudWatch Log Group

resource "aws_cloudwatch_log_group" "main" {
  name = "${local.global_name_prefix}-loggroup"

  tags = merge(local.tags, {
    Name = "${local.global_name_prefix}-loggroup"
  })
}

# Cloudwatch - Code Deploy

resource "aws_cloudwatch_metric_alarm" "codedeploy_rollback" {
  count = var.enable_lb && strcontains(var.deployment_controller, "CODE_DEPLOY") && var.enable_codedeploy_rollback ? 1 : 0

  alarm_name          = "${local.name_prefix}-cdp-rollback"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods = var.codedeploy_rollback_error_evaluation_period
  threshold          = var.codedeploy_rollback_threshold

  # Error Rate / Error amount / Requests amount * 100

  metric_query {
    id = "error_rate"

    expression  = "(errBlue + errGreen) / (rqBlue + rqGreen) * 100"
    label       = "Error Rate"
    return_data = true
  }

  metric_query {
    id = "rqBlue"

    metric {
      metric_name = "RequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = var.codedeploy_rollback_error_evaluation_period
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = var.alb_arn_suffix
        TargetGroup  = aws_alb_target_group.codedeploy["blue"].arn
      }
    }
  }

  metric_query {
    id = "rqGreen"

    metric {
      metric_name = "RequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = var.codedeploy_rollback_error_evaluation_period
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = var.alb_arn_suffix
        TargetGroup  = aws_alb_target_group.codedeploy["green"].arn
      }
    }
  }

  metric_query {
    id = "errBlue"

    metric {
      metric_name = "HTTPCode_Target_5XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = var.codedeploy_rollback_error_evaluation_period
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = var.alb_arn_suffix
        TargetGroup  = aws_alb_target_group.codedeploy["blue"].arn
      }
    }
  }

  metric_query {
    id = "errGreen"

    metric {
      metric_name = "HTTPCode_Target_5XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = var.codedeploy_rollback_error_evaluation_period
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = var.alb_arn_suffix
        TargetGroup  = aws_alb_target_group.codedeploy["green"].arn
      }
    }
  }
}
