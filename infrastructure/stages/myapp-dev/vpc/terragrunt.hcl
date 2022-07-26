# VPC

terraform {
    source = "../../..//modules/aws-ps1-vpc"
}

include {
    path = find_in_parent_folders()
}

locals {
    stage_vars = yamldecode(file(find_in_parent_folders("stage_vars.yml")))
}

inputs = {
    aws_vpc_name = local.stage_vars.stage_slug
    aws_vpc_az_count = 2
    stage_slug = local.stage_vars.stage_slug

    # keep cidr unique to allow for inner-stack communication
    aws_vpc_cidr_block = local.stage_vars.aws_vpc_cidr_block
}
