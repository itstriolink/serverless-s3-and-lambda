# Database

terraform {
    source = "../../..//modules/aws-rds"
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
    rds_name = local.stage_vars.stage_slug
    # only alphanumeric ( no dashes )
    rds_database_name = local.project_vars.name
    rds_apply_immediately = true
    rds_publicly_accessible = true
    rds_instance_class = "db.t3.micro"
    rds_encrypted = false
    rds_deletion_protection = true
    rds_skip_final_snapshot = false
    rds_allocated_storage = 20
    #rds_max_allocated_storage = 1000 # if you want to enable storage autoscaling enter number bigger then `rds_allocated_storage`
    rds_storage_type = "gp2"
    rds_engine_version = "14" # only specify major version, so DB is not attempted to be rebuilt if AWS updates minor version
    vpc_id = dependency.vpc.outputs.vpc_id
    db_subnet_group_subnet_ids = dependency.vpc.outputs.public_subnet_ids # or dependency.vpc.outputs.private_subnet_ids
    # todo, simplify this
    #rds_ingress_security_groups = [
    #    "sg-000000000" # from myapp-dev-backend.outputs.security_group_id
    #]
    #rds_ingress_ip_ranges = [
    #    "0.0.0.0/0"
    #]
    rds_multi_az = false # true if you want standby instances in other AZs
    #rds_snapshot_instance_id = "database-1" # name of running database instance you want to restore from
    #rds_monitoring_interval = 60 # how much seconds passes between monitoring
    #rds_performance_insights_enabled = false # true if you want performance insights enabled
    #rds_performance_insights_retention_period = 7 # how many days should performance insights be retaine
}

# vpc
dependency "vpc" {
    config_path = "../vpc"
}
