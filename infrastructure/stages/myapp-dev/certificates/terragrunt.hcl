# certificates for apps and apis

terraform {
    source = "../../..//modules/aws-utils-acm"
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
    hosted_zone = local.stage_vars.hosted_zone
    aliases = []
    zone_id = local.stage_vars.zone_id
    name = "${local.stage_vars.stage_slug} certificate"
}
