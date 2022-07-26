# Redis

terraform {
    source = "../../..//modules/aws-elasticache-redis"
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
    elasticache_name = local.stage_vars.stage_slug
    elasticache_apply_immediately = true
    elasticache_instance_class = "cache.t2.micro"
    elasticache_engine_version = "6.x"
    vpc_id = dependency.vpc.outputs.vpc_id
    elasticache_subnet_group_subnet_ids = dependency.vpc.outputs.public_subnet_ids # or dependency.vpc.outputs.private_subnet_ids
    # todo, simplify this
    #elasticache_ingress_security_groups = [
    #    "sg-000000000" # from myapp-dev-backend.outputs.security_group_id
    #]
    #elasticache_ingress_ip_ranges = [
    #    "0.0.0.0/0"
    #]
}

# vpc
dependency "vpc" {
    config_path = "../vpc"
}
