/**
* Povio Terraform EventBridge
* Version 2.0
*/

resource "aws_sqs_queue" "queue" {
    name = "${var.stage_slug}-${var.queue_name}"

    visibility_timeout_seconds = var.queue_visibility_timeout
    message_retention_seconds = var.queue_message_retention
    max_message_size = var.queue_max_message_size

    tags = {
        Stage = var.stage_slug
    }
}

resource "aws_sqs_queue_policy" "queue_policy" {
    queue_url = aws_sqs_queue.queue.id

    policy = jsonencode({
        Version = "2012-10-17"
        Id = "${aws_sqs_queue.queue.name}-policy"
        Statement = [
            {
                Sid = "__sender_statement",
                Effect = "Allow",
                Principal = {
                    Service = "events.amazonaws.com"
                },
                Action = [
                    "sqs:SendMessage"
                ],
                Resource = aws_sqs_queue.queue.arn,
                Condition = {
                    ArnEquals = {
                        "aws:SourceArn" = [
                        for rule in aws_cloudwatch_event_rule.rules : rule.arn
                        ]
                    }
                }
            },
            {
                Sid = "__receiver_statement",
                Effect = "Allow",
                Principal = {
                    AWS = var.queue_receiver_arns
                },
                Action = [
                    "sqs:ChangeMessageVisibility",
                    "sqs:DeleteMessage",
                    "sqs:ReceiveMessage",
                    "sqs:GetQueueAttributes",
                ],
                Resource = aws_sqs_queue.queue.arn
            }
        ]
    })
}
