/**
* Povio Terraform EventBridge
* Version 2.0
*/

resource "aws_cloudwatch_event_rule" "rules" {
    for_each = var.rules
    name = "${var.stage_slug}-${each.value.name}"

    description = "Managed by Terraform"

    schedule_expression = each.value.schedule_expression

    tags = {
        Stage = var.stage_slug
    }
}

resource "aws_cloudwatch_event_target" "targets" {
    for_each = var.rules
    rule = aws_cloudwatch_event_rule.rules[each.key].name
    arn  = aws_sqs_queue.queue.arn
    input = jsonencode(each.value.input)
}
