/**
* Povio Terraform SQS App autoscaling
* Version 2.0
*/

resource "aws_appautoscaling_target" "this" {
    min_capacity = var.min_capacity
    max_capacity = var.max_capacity
    resource_id = "service/${var.cluster}/${var.service}"
    scalable_dimension = "ecs:service:DesiredCount"
    service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "up" {
    name = "${var.service}_scale_up"
    resource_id = aws_appautoscaling_target.this.resource_id
    scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
    service_namespace  = aws_appautoscaling_target.this.service_namespace

    step_scaling_policy_configuration {
        adjustment_type = "ChangeInCapacity"
        cooldown = var.up_cooldown
        metric_aggregation_type = "Average"

        step_adjustment {
            metric_interval_lower_bound = var.metric_lower_bound
            scaling_adjustment = var.scaling_up_adjustment
        }
    }
}

resource "aws_appautoscaling_policy" "down" {
    name = "${var.service}_scale_down"
    resource_id = aws_appautoscaling_target.this.resource_id
    scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
    service_namespace  = aws_appautoscaling_target.this.service_namespace

    step_scaling_policy_configuration {
        adjustment_type = "ChangeInCapacity"
        cooldown = var.down_cooldown
        metric_aggregation_type = "Average"

        step_adjustment {
            metric_interval_upper_bound = var.metric_upper_bound
            scaling_adjustment = var.scaling_down_adjustment
        }
    }
}
