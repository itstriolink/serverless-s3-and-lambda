/**
* Povio Terraform Queue
* Version 2.0
*/

output "queue_arn" {
    value = aws_sqs_queue.this.arn
}

output "queue_name" {
    value = aws_sqs_queue.this.name
}

output "queue_url" {
    value = aws_sqs_queue.this.url
}

output "dlq_arn" {
    value = var.has_dlq ? aws_sqs_queue.dlq[0].arn : null
}

output "dlq_name" {
    value = var.has_dlq ? aws_sqs_queue.dlq[0].name : null
}

output "dlq_url" {
    value = var.has_dlq ? aws_sqs_queue.dlq[0].url : null
}
