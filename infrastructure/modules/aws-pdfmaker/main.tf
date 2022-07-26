/**
* Povio Terraform PDF maker
* Version 2.0
*/

# Create the actual Lambda function with extra layers if required
resource "aws_lambda_function" "lambda" {
    filename      = var.lambda_package_path
    function_name = "${var.stage_slug}-${var.lambda_function_name}"
    role          = aws_iam_role.lambda_assume_role.arn
    handler       = var.lambda_function_handler
    memory_size   = var.lambda_memory_size
    layers        = var.lambda_function_layers
    source_code_hash = filebase64sha256(var.lambda_package_path)
    runtime       = var.lambda_runtime
    timeout       = var.lambda_function_timeout

    environment {
        variables = var.lambda_environment
    }
    
    tags = {
        Stage = var.stage_slug
    }
}

