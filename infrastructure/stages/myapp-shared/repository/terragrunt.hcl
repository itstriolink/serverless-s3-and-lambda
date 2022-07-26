# ECS Repository
# The repository is shared between all environments to avoid code rebuilding


terraform {
    source = "../../..//modules/aws-ps1-ecs-repository"
}

include {
    path = find_in_parent_folders()
}

locals {
    stage_vars = yamldecode(file(find_in_parent_folders("stage_vars.yml")))
}

inputs = {
    name = local.stage_vars.stage_slug
}
