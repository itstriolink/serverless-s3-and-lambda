/**
* Povio Terraform PDF maker
* Version 2.0
*/

resource "aws_lambda_permission" "allow_ecs_task" {
    statement_id  = "AllowExecutionFromECSCTask"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.lambda.function_name
    principal     = "ecs-tasks.amazonaws.com"
    source_arn    = var.allow_ecs_task_arn
}
