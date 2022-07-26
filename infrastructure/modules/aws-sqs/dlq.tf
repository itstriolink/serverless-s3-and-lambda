/**
* Povio Terraform Queue
* Version 2.0
*/

resource "aws_sqs_queue" "dlq" {
    count = var.has_dlq ? 1 : 0

    name = "${var.stage_slug}-${var.queue_name}-dlq${var.is_fifo ? ".fifo" : ""}"

    visibility_timeout_seconds = var.dlq_visibility_timeout
    message_retention_seconds = var.dlq_message_retention
    max_message_size = var.max_message_size # keep max_message_size same in both queues
    delay_seconds = var.dlq_delay_seconds

    fifo_queue = var.is_fifo # if primary queue is FIFO, DLQ must also be FIFO
    deduplication_scope = var.deduplication_scope
    fifo_throughput_limit = var.fifo_throughput_limit
    content_based_deduplication = var.content_based_deduplication

    tags = {
        Stage = var.stage_slug
    }
}
