/**
* Povio Terraform App autoscaling
* Version 2.0
*/

resource "aws_appautoscaling_target" "this" {
    for_each = var.services
    min_capacity = each.value.min_capacity
    max_capacity = each.value.max_capacity
    resource_id = "service/${each.value.cluster}/${each.value.service}"
    scalable_dimension = "ecs:service:DesiredCount"
    service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "up" {
    for_each = var.services
    name = "${each.value.service}_scale_up"
    resource_id = aws_appautoscaling_target.this[each.key].resource_id
    scalable_dimension = aws_appautoscaling_target.this[each.key].scalable_dimension
    service_namespace  = aws_appautoscaling_target.this[each.key].service_namespace

    step_scaling_policy_configuration {
        adjustment_type = "ChangeInCapacity"
        cooldown = each.value.up_cooldown
        metric_aggregation_type = "Average"

        step_adjustment {
            metric_interval_lower_bound = each.value.metric_lower_bound
            scaling_adjustment = each.value.scaling_up_adjustment
        }
    }
}

resource "aws_appautoscaling_policy" "down" {
    for_each = var.services
    name = "${each.value.service}_scale_down"
    resource_id = aws_appautoscaling_target.this[each.key].resource_id
    scalable_dimension = aws_appautoscaling_target.this[each.key].scalable_dimension
    service_namespace  = aws_appautoscaling_target.this[each.key].service_namespace

    step_scaling_policy_configuration {
        adjustment_type = "ChangeInCapacity"
        cooldown = each.value.down_cooldown
        metric_aggregation_type = "Average"

        step_adjustment {
            metric_interval_upper_bound = each.value.metric_upper_bound
            scaling_adjustment = each.value.scaling_down_adjustment
        }
    }
}



