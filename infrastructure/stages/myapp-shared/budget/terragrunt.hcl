# AWS budget definition
# The budget is defined for entire project.


terraform {
    source = "../../..//modules/aws-project-budget"
}

include {
    path = find_in_parent_folders()
}

locals {
    stage_vars = yamldecode(file(find_in_parent_folders("stage_vars.yml")))
    project_vars = yamldecode(file(find_in_parent_folders("project_vars.yml")))
}

inputs = {
    budget_name = local.stage_vars.stage_slug
    //budget_amount = local.project_vars.budget_amount // defaults to 100
    //budget_unit = local.project_vars.budget_unit // defaults to USD
    //budget_notification_threshold = local.project_vars.budget_notification_threshold // defaults to 80
    budget_notification_adresses = local.project_vars.budget_notification_addresses // must be set
    //budget_time_period_start = local.project_vars.budget_time_period_start // defaults to 2021-07-01_00:00
}
