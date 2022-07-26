/**
* Povio Terraform App autoscaling
* Version 2.0
*/

resource "aws_cloudwatch_metric_alarm" "up_alarms" {
    for_each = var.scale_up_alarms
    alarm_name = "${var.stage_slug}_${each.key}"
    comparison_operator = each.value.operator
    evaluation_periods = each.value.evaluation_periods
    metric_name = each.value.metric_name
    namespace = "AWS/ECS"
    period = each.value.period
    statistic = each.value.statistic
    threshold = each.value.threshold
    datapoints_to_alarm = each.value.datapoints

    dimensions = {
        ClusterName: var.services[each.value.service_key].cluster
        ServiceName: var.services[each.value.service_key].service
    }

    alarm_description = "Managed by Terraform"
    alarm_actions = [aws_appautoscaling_policy.up[each.value.service_key].arn]
    
    tags = {
        Stage = var.stage_slug
    }
}

resource "aws_cloudwatch_metric_alarm" "down_alarms" {
    for_each = var.scale_down_alarms
    alarm_name = "${var.stage_slug}_${each.key}"
    comparison_operator = each.value.operator
    evaluation_periods = each.value.evaluation_periods
    metric_name = each.value.metric_name
    namespace = "AWS/ECS"
    period = each.value.period
    statistic = each.value.statistic
    threshold = each.value.threshold
    datapoints_to_alarm = each.value.datapoints

    dimensions = {
        ClusterName: var.services[each.value.service_key].cluster
        ServiceName: var.services[each.value.service_key].service
    }

    alarm_description = "Managed by Terraform"
    alarm_actions = [aws_appautoscaling_policy.down[each.value.service_key].arn]
    
    tags = {
        Stage = var.stage_slug
    }
}
