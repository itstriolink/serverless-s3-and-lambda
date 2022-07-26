/**
* Povio Terraform PS1
* Version 2.0
*/

#
# Configure Policies for ECS Task Executor
#

data "aws_iam_policy_document" "ecs_execution_principal" {
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

data "aws_iam_policy_document" "ecs_execution" {
    statement {
        sid = "ServiceDefaults"
        effect = "Allow"
        actions = [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
        resources = [
            "*"
        ]
    }
    # If secrets have been provided with the container defs, then an extra statement block will be created
    # that will allow the exec to pull those secrets and inject them into the container runtime.
    dynamic "statement" {
        for_each = length(local.extracted_container_secrets) > 0 ? [
            "enabled"
        ] : []
        content {
            sid = "ServiceSecrets"
            effect = "Allow"
            actions = [
                "ssm:GetParameter",
                "ssm:GetParameters",
                "secretsmanager:GetSecretValue",
                "kms:Decrypt"
            ]
            resources = concat(local.extracted_container_secrets.*.valueFrom, [var.ssm_kms_key_arn])
        }
    }
    # If we want to handle ssm injection dynamically at deploy, we just need permissions for the executor
    dynamic "statement" {
        for_each = length(var.container_executor_ssm_and_secret_arns) > 0 ? [
            "enabled"] : []
        content {
            sid = "ServiceExtraSecrets"
            effect = "Allow"
            actions = [
                "ssm:GetParameter",
                "ssm:GetParameters",
                "ssm:GetParametersByPath",
                "secretsmanager:GetSecretValue", # also works for secrets
            ]
            resources = var.container_executor_ssm_and_secret_arns
        }
    }
}

resource "aws_iam_role" "ecs_task_execution_role" {
    name = "${var.stage_slug}-${var.name}-exec-basic"
    assume_role_policy = data.aws_iam_policy_document.ecs_execution_principal.json

    tags = {
        Stage = var.stage_slug
    }
}

resource "aws_iam_role_policy" "ecs_execution" {
    name = "${var.stage_slug}-${var.name}-exec-basic"
    role = aws_iam_role.ecs_task_execution_role.id
    policy = data.aws_iam_policy_document.ecs_execution.json
}
