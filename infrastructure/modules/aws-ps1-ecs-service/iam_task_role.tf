/**
* Povio Terraform PS1
* Version 2.0
*/

#
# Configure Policies for ECS Task Role
#

data "aws_iam_policy_document" "ecs_task_role_principal" {
    statement {
        effect = "Allow"
        actions = [
            "sts:AssumeRole"
        ]
        principals {
            type = "Service"
            identifiers = [
                "ecs-tasks.amazonaws.com"
            ]
        }
    }
}

data "aws_iam_policy_document" "task_role_execution" {
    dynamic "statement" {
        for_each = length(var.container_task_ssm_and_secret_arns) > 0 ? [
            "enabled"
        ] : []
        content {
            sid = "ServiceExtraSecrets"
            effect = "Allow"
            actions = [
                "ssm:GetParameter",
                "ssm:GetParameters",
                "ssm:GetParametersByPath",
                "secretsmanager:GetSecretValue", # also works for secrets
            ]
            resources = var.container_task_ssm_and_secret_arns
        }
    }
    dynamic "statement" {
        for_each = toset(var.aws_s3_buckets)
        content {
            effect = "Allow"
            actions = [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObject",
                "s3:DeleteObject"
            ]
            resources = ["${statement.value}/*"]
        }
    }
    dynamic "statement" {
        for_each = length(var.container_task_extra_permissions) > 0 ? toset(var.container_task_extra_permissions) : []
        content {
            effect = "Allow"
            actions = statement.value.actions
            resources = statement.value.resources
        }
    }
}


resource "aws_iam_role" "ecs_task_role" {
    name = "${var.stage_slug}-${var.name}-task-role"
    assume_role_policy = data.aws_iam_policy_document.ecs_task_role_principal.json

    tags = {
        Stage = var.stage_slug
    }
}

resource "aws_iam_role_policy" "ecs_task_role_policy" {
    count = length(var.container_task_ssm_and_secret_arns) > 0 || length(var.aws_s3_buckets) > 0 || length(var.container_task_extra_permissions) > 0 ? 1 : 0

    name = "${var.stage_slug}-${var.name}-task-role"
    role = aws_iam_role.ecs_task_role.id
    policy = data.aws_iam_policy_document.task_role_execution.json
}
