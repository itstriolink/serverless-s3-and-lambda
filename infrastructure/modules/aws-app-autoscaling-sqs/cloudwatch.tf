/**
* Povio Terraform SQS App autoscaling
* Version 2.0
*/

resource "aws_cloudwatch_metric_alarm" "up_alarm" {
    alarm_name = "${var.service}-backlog_up"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = 1
    threshold = "1"


    metric_query {
        id = "e1"
        expression = "MAX(METRICS(\"qm\"))/FILL(sm1, 1)"
        label = "Backlog per instance"
        return_data = true
    }


    dynamic "metric_query" {
        for_each = var.queues
        content {
            id = "qm${metric_query.key + 1}"

            metric {
                metric_name = "ApproximateNumberOfMessagesVisible"
                namespace = "AWS/SQS"
                period = 60
                stat = "Sum"

                dimensions = {
                    QueueName = metric_query.value
                }
            }
        }
    }

    metric_query {
        id = "sm1"

        metric {
            metric_name = "CPUUtilization"
            namespace = "AWS/ECS"
            period = 60
            stat = "SampleCount"

            dimensions = {
                ClusterName: var.cluster
                ServiceName: var.service
            }
        }
    }


    alarm_description = "Managed by Terraform"
    alarm_actions = [aws_appautoscaling_policy.up.arn]
    
    tags = {
        Stage = var.stage_slug
    }
}

resource "aws_cloudwatch_metric_alarm" "down_alarm" {
    alarm_name = "${var.service}-backlog_down"
    comparison_operator = "LessThanThreshold"
    evaluation_periods = 1
    threshold = 1

    metric_query {
        id = "e1"
        expression = "MAX(METRICS(\"qm\"))/FILL(sm1, 1)"
        label = "Backlog per instance"
        return_data = true
    }

    dynamic "metric_query" {
        for_each = var.queues

        content {
            id = "qm${metric_query.key + 1}"

            metric {
                metric_name = "ApproximateNumberOfMessagesVisible"
                namespace = "AWS/SQS"
                period = 60
                stat = "Sum"

                dimensions = {
                    QueueName = metric_query.value
                }
            }
        }
    }

    metric_query {
        id = "sm1"

        metric {
            metric_name = "CPUUtilization"
            namespace = "AWS/ECS"
            period = 60
            stat = "SampleCount"

            dimensions = {
                ClusterName: var.cluster
                ServiceName: var.service
            }
        }
    }

    alarm_description = "Managed by Terraform"
    alarm_actions = [aws_appautoscaling_policy.down.arn]
    
    tags = {
        Stage = var.stage_slug
    }
}
