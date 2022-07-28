# PDF maker lambda
# PDF maker is shared between all environments to avoid code rebuilding

terraform {
    source = "../../..//modules/aws-lambda"
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
    region = local.project_vars.aws_region
    lambda_timeout = 29
    lambda_memory_size = 1024
}
