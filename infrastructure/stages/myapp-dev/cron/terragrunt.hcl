# Cron

terraform {
  source = "../../..//modules/aws-eventbridge-rule-to-sqs"
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

  rules = {
    scheduledReports: {
      name: "Cron",
      schedule_expression: "cron(0 5 * * ? *)"
      input: {

      }
    },
  }

  queue_name = "cron"
  queue_receiver_arns = [
    dependency.backend.outputs.ecs_task_iam_role_arn,
  ]
}

# backend
dependency "backend" {
  config_path = "../backend"
}
