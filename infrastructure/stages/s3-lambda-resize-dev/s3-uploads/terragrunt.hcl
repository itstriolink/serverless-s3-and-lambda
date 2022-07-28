# VPC

terraform {
    source = "../../..//modules/aws-s3-private-bucket"
}

include {
    path = find_in_parent_folders()
}

locals {
    stage_vars = yamldecode(file(find_in_parent_folders("stage_vars.yml")))
}

inputs = {
    bucket_name = "${local.stage_vars.stage_slug}-uploads"
    stage_slug = local.stage_vars.stage_slug
    enable_versioning = false
    enable_mfa_delete = false
    acceleration_status = "Suspended"
    lambda_arn = dependency.lambda.outputs.arn
}

# s3 uploads
dependency "lambda" {
  config_path = "../lambda"
}