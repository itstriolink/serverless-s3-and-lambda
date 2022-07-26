/**
* Povio Terraform PDF maker
* Version 2.0
*/

# Common variables for all modules.

variable "stage_slug" {
    description = "Slug of the stage (environment)"
    type = string
}

# Lambda specific variables

variable "lambda_package_path" {
    description = "Path to the zip file containing Lamba function"
    type = string
}

variable "lambda_function_name" {
    description = "Lambda function name"
    type = string
}

variable "lambda_function_handler" {
    description = "Lamdba function handler. Should be in format of filename.main_function"
    type = string
    default = "lambda_function.lambda_handler"
}

variable "lambda_runtime" {
    description = "Lambda runtime definition"
    type = string
    default = "nodejs14.x"
}

variable "lambda_environment" {
    description = "Lambda runtime environment"
    type = map(string)
    default = {}
}

variable "lambda_memory_size" {
    description = "Memory size allocated for lambda function"
    type = number
    default = 128
}

variable "lambda_function_layers" {
    description = "Layers required for lambda function"
    type = list(string)
    default = []
}

variable "lambda_function_timeout" {
    description = "Timeout for lambda function"
    type = number
    default = 10
}

variable "allow_ecs_task_arn" {
    description = "ARN of ECS task that can invoke lambda function"
    type = string
}
