/**
* Povio Terraform PDF maker
* Version 2.0
*/

output "aws_lambda_function_name" {
    description = "AWS Lambda function name"
    value = aws_lambda_function.lambda.function_name
}

output "aws_lambda_function_arn" {
    description = "AWS Lambda function arn"
    value = aws_lambda_function.lambda.arn
}

output "aws_iam_lambda_user_group" {
    description = "IAM User group allowed to execute lambda functions"
    value = aws_iam_group.run_lambda.name
}

output "aws_iam_lambda_user_group_arn" {
    description = "IAM User group allowed to execute lambda functions arn"
    value = aws_iam_group.run_lambda.arn
}

output "aws_lambda_runner_key_id" {
    description = "AWS IAM key id for lambda runner user"
    value = aws_iam_access_key.lambda_runner.id
}

output "aws_lambda_runner_secret_key" {
    description = "AWS IAM secret key for lambda runner user"
    value = aws_iam_access_key.lambda_runner.secret
    sensitive = true
}
