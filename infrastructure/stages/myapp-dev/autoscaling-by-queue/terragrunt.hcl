# VPC

terraform {
    source = "../../..//modules/aws-app-autoscaling-sqs"
}

include {
    path = find_in_parent_folders()
}

locals {
    stage_vars = yamldecode(file(find_in_parent_folders("stage_vars.yml")))
}

inputs = {
    stage_slug = local.stage_vars.stage_slug

    cluster = dependency.loadbalancer.outputs.cluster_name
    service = dependency.backend.outputs.ecs_service_name
    queues = [
        dependency.sqs_queue.outputs.queue_name
    ]

    min_capacity = 0
    max_capacity = 5

    up_cooldown = 60
    down_cooldown = 180

    metric_lower_bound = 0
    metric_upper_bound = 0

    scaling_up_adjustment = 1
    scaling_down_adjustment = -1
}

# backend
dependency "backend" {
    config_path = "../backend"
}

# load balancer
dependency "loadbalancer" {
    config_path = "../loadbalancer"
}

# queue
dependency "sqs_queue" {
    config_path = "../sqs-queue"
}
