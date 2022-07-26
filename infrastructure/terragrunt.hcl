locals {
  project_vars = yamldecode(file("project_vars.yml"))
}

# default backend
remote_state {
  backend = "s3"
  config = {
    # the AWS local profile
    profile = "${local.project_vars.aws_profile}"

    # the bucket to store the state in
    bucket = "${local.project_vars.name}-terraform-state"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region = "${local.project_vars.aws_region}"
    encrypt = true

    # the dynamodb table for state locking
    dynamodb_table = "${local.project_vars.name}-terraform-lock"
  }
}

# default provider config
generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
    # only allow deployment on this accountId for safety reasons
    allowed_account_ids = ["${local.project_vars.aws_account_id}"]
    region = "${local.project_vars.aws_region}"
    profile = "${local.project_vars.aws_profile}"
}
# same as above but should be region=us-east-1 for certificates
provider "aws" {
    alias = "virginia"
    # only allow deployment on this accountId for safety reasons
    allowed_account_ids = ["${local.project_vars.aws_account_id}"]
    region = "us-east-1"
    profile = "${local.project_vars.aws_profile}"
}
terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "${local.project_vars.aws_provider_version}"
        }
    }

    backend "s3" {}
    # for S3 buckets enable optional attribute for variables
    # experiments = [
    #     module_variable_optional_attrs
    # ]
}
EOF
}
