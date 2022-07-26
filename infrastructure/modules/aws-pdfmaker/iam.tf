/**
* Povio Terraform PDF maker
* Version 2.0
*/

# Allow lambda functions to assume roles in AWS IAM
# Required to access extra resources like logging, etc
# https://aws.amazon.com/blogs/security/how-to-use-trust-policies-with-iam-roles/
resource "aws_iam_role" "lambda_assume_role" {
    name = "${var.stage_slug}-${var.lambda_function_name}-lambda-assume-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Action = "sts:AssumeRole",
                Principal = {
                    Service = "lambda.amazonaws.com"
                },
                Effect = "Allow",
                Sid = ""
            }
        ]
    })
    
    tags = {
        Stage = var.stage_slug
    }
}

# Attach Lambda executor Role to AWS Lambda Basic Execution Role policy
# to allow function to upload logs to CloudWatch
# https://docs.aws.amazon.com/lambda/latest/dg/lambda-intro-execution-role.html
resource "aws_iam_role_policy_attachment" "lambda_execution_role" {
    role       = aws_iam_role.lambda_assume_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Attach run_lambda_policy to run_lambda group
# group members can execute lambda functions
resource "aws_iam_group_policy_attachment" "run_lambda_attach_role" {
    group      = aws_iam_group.run_lambda.name
    policy_arn = aws_iam_policy.run_lambda_policy.arn
}

# Create an IAM user that can execute lambda function
# and assign it to to run_lambda group

resource "aws_iam_user" "lambda_runner" {
    name = "${var.stage_slug}-${var.lambda_function_name}-runner"
    tags = {
        stage = var.stage_slug
    }
}

resource "aws_iam_user_group_membership" "lambda_runner"  {
    user = aws_iam_user.lambda_runner.name
    groups = [
        aws_iam_group.run_lambda.name,
    ]
}

# create IAM access key for lambda_runner user
resource "aws_iam_access_key" "lambda_runner" {
    user = aws_iam_user.lambda_runner.name
}

# Create a user group for users to run lambda functions using AWS provided policy
# https://docs.aws.amazon.com/lambda/latest/dg/access-control-identity-based.html
resource "aws_iam_group" "run_lambda" {
    name = "${var.stage_slug}-${var.lambda_function_name}-run-lambda"
}

resource "aws_iam_policy" "run_lambda_policy" {
    name = "${var.stage_slug}-${var.lambda_function_name}-run-lambda-policy"
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Sid = "Invoke",
                Effect = "Allow",
                Action = [
                    "lambda:InvokeFunction"
                ],
                Resource = aws_lambda_function.lambda.arn
            }
        ]
    })
    
    tags = {
        Stage = var.stage_slug
    }
}
