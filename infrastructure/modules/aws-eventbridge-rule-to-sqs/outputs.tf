/**
* Povio Terraform EventBridge
* Version 2.0
*/

output "rules_arns" {
    value = [
    for rule in aws_cloudwatch_event_rule.rules : rule.arn
    ]
}

output "queue_arn" {
    value = aws_sqs_queue.queue.arn
}

output "queue_name" {
    value = aws_sqs_queue.queue.name
}

output "queue_url" {
    value = aws_sqs_queue.queue.url
}
