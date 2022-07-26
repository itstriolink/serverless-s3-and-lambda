# VPC

terraform {
    source = "../../..//modules/aws-ps1-ecs-service"
}

include {
    path = find_in_parent_folders()
}

locals {
    stage_vars = yamldecode(file(find_in_parent_folders("stage_vars.yml")))
    project_vars = yamldecode(file(find_in_parent_folders("project_vars.yml")))
    name = "backend"
}

inputs = {
    # when running for the first time, use the env variable TF_VAR_first_run=true
    # TF_VAR_first_run=true terragrunt apply
    first_run = false
    name = local.name

    # use FARGATE_SPOT for development and tasks
    fargate_capacity_provider = "FARGATE"

    # the path LB serves for this service
    target_path_patterns = ["/*"]
    # target_domains = []

    stage_slug = local.stage_vars.stage_slug

    service_desired_count = 1
    task_definition_cpu = 256 # == 0.25 vCPU
    task_definition_memory = 512

    # starting image - will be replaced with CICD (see first_run above)
    task_definition_image = "nginx:latest"

    # if we should keep the old environment (set via CICD for example)
    merge_existing_container_environment = true

    # Inject environment
    #  this can get overwritten at task deployment using ecs-deploy.sh
    container_environment = {
        STAGE = local.stage_vars.stage_slug

        # examples from nestjs-template
        NODE_ENV = "PRODUCTION"
        CORS_URL = "*"
        PORT = 80,
        TYPEORM_CONNECTION = "postgres"
        TYPEORM_HOST = dependency.database.outputs.rds_address
        TYPEORM_PORT = dependency.database.outputs.rds_port
        TYPEORM_USERNAME = dependency.database.outputs.rds_username
        TYPEORM_DATABASE = dependency.database.outputs.rds_database_name
    }

    # adding a new secret / variable from ssm or secrets just by defining
    # will also give permission to the execution tole to inject the secrets
    container_secrets = {
        TYPEORM_PASSWORD = dependency.database.outputs.rds_master_password_secret_arn
    }

    # give permission to access ssm/secret to the deploy script
    container_executor_ssm_and_secret_arns = [
        # defines what the container execution (deploy time) has permissions to read
        # great when letting the CICD add new secrets
        "arn:aws:ssm:us-east-1:${local.project_vars.aws_account_id}:parameter/${local.stage_vars.stage_slug}",
        "arn:aws:ssm:us-east-1:${local.project_vars.aws_account_id}:parameter/${local.stage_vars.stage_slug}/*"
    ]

    # give permission to access ssm/secret to the runtime task
    container_task_ssm_and_secret_arns = [
        # defines what the container task has permissions to read at runtime
        # naming convention permits us to define new SSM parameters without changing the infrastructure
        #"arn:aws:ssm:us-east-1:${local.project_vars.aws_account_id}:parameter/${local.stage_vars.stage_slug}",
        #"arn:aws:ssm:us-east-1:${local.project_vars.aws_account_id}:parameter/${local.stage_vars.stage_slug}/*"
    ]

    ssm_kms_key_arn = local.project_vars.aws_ssm_kms_key_arn
    health_check_path = "/"
    target_port = 80
    task_definition_port_container = 80
    task_definition_awslogs_region = local.project_vars.aws_region
    task_definition_awslogs_stream_prefix = "${local.stage_vars.stage_slug}-${local.name}"
    vpc_id = dependency.vpc.outputs.vpc_id
    service_allowed_security_group_ids = [dependency.loadbalancer.outputs.security_group_public_id]
    ecs_cluster_id = dependency.loadbalancer.outputs.cluster_id
    ecs_cluster_name = dependency.loadbalancer.outputs.cluster_name
    service_subnet_ids = dependency.vpc.outputs.public_subnet_ids # or dependency.vpc.outputs.private_subnet_ids
    aws_alb_listener_arn = dependency.loadbalancer.outputs.load_balancer_listener_arn
    #aws_s3_buckets = [ dependency.s3-uploads.outputs.bucket_arn ]
}

# db
dependency "database" {
    config_path = "../database"
}

# vpc
dependency "vpc" {
    config_path = "../vpc"
}

# backend
dependency "loadbalancer" {
    config_path = "../loadbalancer"
}

# s3 uploads
#dependency "s3-uploads" {
#    config_path = "../s3-uploads"
#}
