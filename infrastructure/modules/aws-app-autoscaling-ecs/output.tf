/**
* Povio Terraform App autoscaling
* Version 2.0
*/

output "autoscaling_targets" {
    value = aws_appautoscaling_target.this
}

output "autoscaling_up_policies" {
    value = aws_appautoscaling_policy.up
}

output "autoscaling_down_policies" {
    value = aws_appautoscaling_policy.down
}

output "cloudwatch_up_alarms" {
    value = aws_cloudwatch_metric_alarm.up_alarms
}

output "cloudwatch_down_alarms" {
    value = aws_cloudwatch_metric_alarm.down_alarms
}
