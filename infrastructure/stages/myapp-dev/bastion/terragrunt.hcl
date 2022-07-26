# VPC

terraform {
    source = "../../..//modules/aws-ps1-bastion"
}

include {
    path = find_in_parent_folders()
}

locals {
    stage_vars = yamldecode(file(find_in_parent_folders("stage_vars.yml")))
}

inputs = {
    stage_slug = local.stage_vars.stage_slug
    subnet_id = dependency.vpc.outputs.public_subnet_ids[0]
    vpc_id = dependency.vpc.outputs.vpc_id
}

# vpc
dependency "vpc" {
    config_path = "../vpc"
}
