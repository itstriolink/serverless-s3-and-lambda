# VPC

terraform {
    source = "../../..//modules/aws-sqs"
}

include {
    path = find_in_parent_folders()
}

locals {
    stage_vars = yamldecode(file(find_in_parent_folders("stage_vars.yml")))
}

inputs = {
    queue_name = "queue"
    stage_slug = local.stage_vars.stage_slug
    visibility_timeout = 30
    message_retention = 86400 # 1 day

    has_dlq = true
    dlq_visibility_timeout = 900
    dlq_message_retention = 604800 # 1 week
    retry = 3

    receiver_arns = [
        dependency.backend.outputs.ecs_task_iam_role_arn
    ]
    sender_arns = [
        dependency.backend.outputs.ecs_task_iam_role_arn
    ]
}

dependency "backend" {
    config_path = "../backend"
}
