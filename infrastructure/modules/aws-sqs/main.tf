/**
* Povio Terraform Queue
* Version 2.0
*/

resource "aws_sqs_queue" "this" {
    name = "${var.stage_slug}-${var.queue_name}${var.is_fifo ? ".fifo" : ""}"

    visibility_timeout_seconds = var.visibility_timeout
    message_retention_seconds = var.message_retention
    max_message_size = var.max_message_size
    delay_seconds = var.delay_seconds

    fifo_queue = var.is_fifo
    deduplication_scope = var.deduplication_scope
    content_based_deduplication = var.content_based_deduplication
    fifo_throughput_limit = var.fifo_throughput_limit

    redrive_policy = var.has_dlq ? jsonencode({
        deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
        maxReceiveCount = var.retry
    }) : null


    tags = {
        Stage = var.stage_slug
    }
}

resource "aws_sqs_queue_policy" "this" {
    queue_url = aws_sqs_queue.this.id

    policy = jsonencode({
        Version = "2012-10-17"
        Id = "${aws_sqs_queue.this.name}-policy"
        Statement = [
            {
                Sid = "__sender_statement",
                Effect = "Allow",
                Principal = {
                    AWS = var.sender_arns
                },
                Action = [
                    "sqs:SendMessage"
                ],
                Resource = aws_sqs_queue.this.arn
            },
            {
                Sid = "__receiver_statement",
                Effect = "Allow",
                Principal = {
                    AWS = var.receiver_arns
                },
                Action = [
                    "sqs:ChangeMessageVisibility",
                    "sqs:DeleteMessage",
                    "sqs:ReceiveMessage",
                    "sqs:GetQueueAttributes", # if using squiss-ts as consumer (NestJS template SQS) this must be present or consumer will throw errors
                ],
                Resource = aws_sqs_queue.this.arn
            }
        ]
    })
}
