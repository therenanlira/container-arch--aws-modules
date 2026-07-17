# Autoscaling

resource "aws_appautoscaling_target" "main" {
  min_capacity = var.task_min
  max_capacity = var.task_max

  resource_id = reverse(split(":", aws_ecs_service.main.id))[0]

  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Autoscaling Out CPU

resource "aws_appautoscaling_policy" "cpu_high" {
  count = strcontains(var.scale_type, "cpu") ? 1 : 0

  name = "${local.name_prefix}-cpu-scale-out"

  resource_id        = aws_appautoscaling_target.main.resource_id
  service_namespace  = aws_appautoscaling_target.main.service_namespace
  scalable_dimension = aws_appautoscaling_target.main.scalable_dimension

  policy_type = "StepScaling"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.scale_out_cpu.cooldown
    metric_aggregation_type = var.scale_out_cpu.statistic

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = var.scale_out_cpu.adjustment
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  count = strcontains(var.scale_type, "cpu") ? 1 : 0

  alarm_name = "${local.name_prefix}-cpu-scale-out"

  comparison_operator = var.scale_out_cpu.comparison_operator

  metric_name = "CPUUtilization"
  namespace   = "AWS/ECS"
  statistic   = var.scale_out_cpu.statistic

  period             = var.scale_out_cpu.period
  evaluation_periods = var.scale_out_cpu.evaluation_periods
  threshold          = var.scale_out_cpu.threshold

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }

  alarm_actions = [
    aws_appautoscaling_policy.cpu_high[count.index].arn
  ]

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-cpu-scale-out"
  })
}

# Autoscaling In CPU

resource "aws_appautoscaling_policy" "cpu_low" {
  count = strcontains(var.scale_type, "cpu") ? 1 : 0

  name = "${local.name_prefix}-cpu-scale-in"

  resource_id        = aws_appautoscaling_target.main.resource_id
  service_namespace  = aws_appautoscaling_target.main.service_namespace
  scalable_dimension = aws_appautoscaling_target.main.scalable_dimension

  policy_type = "StepScaling"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.scale_in_cpu.cooldown
    metric_aggregation_type = var.scale_in_cpu.statistic

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = var.scale_in_cpu.adjustment
    }

    step_adjustment {
      metric_interval_lower_bound = 0
      metric_interval_upper_bound = var.scale_in_cpu.threshold
      scaling_adjustment          = var.scale_in_cpu.adjustment
    }

    step_adjustment {
      metric_interval_lower_bound = var.scale_in_cpu.threshold
      scaling_adjustment          = 0
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  count = strcontains(var.scale_type, "cpu") ? 1 : 0

  alarm_name = "${local.name_prefix}-cpu-scale-in"

  comparison_operator = var.scale_in_cpu.comparison_operator

  metric_name = "CPUUtilization"
  namespace   = "AWS/ECS"
  statistic   = var.scale_in_cpu.statistic

  period             = var.scale_in_cpu.period
  evaluation_periods = var.scale_in_cpu.evaluation_periods
  threshold          = var.scale_in_cpu.threshold

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }

  alarm_actions = [
    aws_appautoscaling_policy.cpu_low[count.index].arn
  ]

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-cpu-scale-in"
  })
}

# Autoscaling tracking CPU

resource "aws_appautoscaling_policy" "cpu_target_tracking" {
  count = strcontains(var.scale_type, "cpu-tracking") ? 1 : 0

  name = "${local.name_prefix}-cpu-tracking"

  resource_id        = aws_appautoscaling_target.main.resource_id
  service_namespace  = aws_appautoscaling_target.main.service_namespace
  scalable_dimension = aws_appautoscaling_target.main.scalable_dimension

  policy_type = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value       = var.scale_tracking_cpu
    scale_out_cooldown = var.scale_out_cpu.cooldown
    scale_in_cooldown  = var.scale_in_cpu.cooldown

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

# Autoscaling tracking Requests

resource "aws_appautoscaling_policy" "requests_target_tracking" {
  count = strcontains(var.scale_type, "requests-tracking") ? 1 : 0

  name = "${local.name_prefix}-requests-tracking"

  resource_id        = aws_appautoscaling_target.main.resource_id
  service_namespace  = aws_appautoscaling_target.main.service_namespace
  scalable_dimension = aws_appautoscaling_target.main.scalable_dimension

  policy_type = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value       = var.scale_tracking_cpu
    scale_out_cooldown = var.scale_out_cpu.cooldown
    scale_in_cooldown  = var.scale_in_cpu.cooldown

    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${data.aws_alb.main.arn_suffix}/${aws_alb_target_group.main.arn_suffix}"
    }
  }
}
