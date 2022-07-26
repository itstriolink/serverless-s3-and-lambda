# Lambda function definition.

terraform {
    source = "../../..//modules/aws-pdfmaker"
}

include {
    path = find_in_parent_folders()
}

locals {
    stage_vars = yamldecode(file(find_in_parent_folders("stage_vars.yml")))
    project_vars = yamldecode(file(find_in_parent_folders("project_vars.yml")))
}

inputs = {
    stage_slug = local.stage_vars.stage_slug
    lambda_package_path = "pdfmaker.zip"
    lambda_function_name = "pdfmaker"
    lambda_function_handler = "pdfmaker.handler"
    lambda_runtime = "nodejs14.x"
    lambda_memory_size = 512
    lambda_function_timeout = 15
    lambda_environment = {
        STAGE: "${local.stage_vars.stage_slug}"
    }
    lambda_function_layers = [
        "arn:aws:lambda:${local.project_vars.aws_region}:764866452798:layer:chrome-aws-lambda:24"
    ]

    allow_ecs_task_arn = "arn:aws:ecs:${local.project_vars.aws_region}:${local.project_vars.aws_account_id}:task/default"

}
