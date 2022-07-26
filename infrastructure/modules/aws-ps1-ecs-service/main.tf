/**
* Povio Terraform PS1
* Version 2.0
*/

#
# Create ECS Task Definition, Service and Container Definition.
#

# get image name from the current (previous) definition
data "aws_ecs_task_definition" "previous" {
    count = var.first_run ? 0 : 1
    task_definition = "${var.stage_slug}-${var.name}"
}
data "aws_ecs_container_definition" "previous" {
    count = var.first_run ? 0 : 1
    task_definition = data.aws_ecs_task_definition.previous[0].family
    container_name = "${var.stage_slug}-${var.name}"
}

locals {
    log_group_name = "/ecs/${var.stage_slug}/${var.name}"

    # get image name from the current (previous) definition if set
    task_definition_image = var.first_run ? var.task_definition_image : data.aws_ecs_container_definition.previous[0].image

    existing_container_environment = !var.first_run && var.merge_existing_container_environment  ? data.aws_ecs_container_definition.previous[0].environment: {}
    container_environment = merge( local.existing_container_environment, var.container_environment )

    # todo, this does not exist yet
    # existing_container_secrets = !var.first_run && var.merge_existing_container_environment  ? data.aws_ecs_container_definition.previous[0].secrets: {}
    #container_secrets = merge( local.existing_container_secrets, var.container_secrets )
    container_secrets = var.container_secrets

    container_definitions = [
        {
            cpu = var.task_definition_cpu,
            image = local.task_definition_image,
            memory = var.task_definition_memory,
            name = "${var.stage_slug}-${var.name}"
            networkMode = "awsvpc",
            essential = true,
            mountPoints = []
            volumesFrom = []
            portMappings = [
                {
                    hostPort = var.task_definition_port_container,
                    protocol = "tcp",
                    containerPort = var.task_definition_port_container
                }
            ],
            logConfiguration = {
                logDriver = "awslogs",
                options = {
                    awslogs-group = local.log_group_name,
                    awslogs-region = var.task_definition_awslogs_region,
                    awslogs-stream-prefix = var.task_definition_awslogs_stream_prefix
                }
            },
            environment = [for k, v in local.container_environment : tomap({
                name = k,
                value = v
            })],
            secrets = [for k, v in local.container_secrets : tomap({
                name = k,
                valueFrom = v
            })]
        }
    ]
    extracted_container_secrets = flatten([for c in local.container_definitions : try(c.secrets, [])])
}

# create Cloud Watch log group
resource "aws_cloudwatch_log_group" "this" {
    name = local.log_group_name
    tags = {
        Stage = var.stage_slug
    }
}


# Create ECS Task Definition
resource "aws_ecs_task_definition" "this" {
    family = "${var.stage_slug}-${var.name}"
    cpu = var.task_definition_cpu
    memory = var.task_definition_memory
    network_mode = "awsvpc"
    requires_compatibilities = [
        "FARGATE"
    ]
    execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
    task_role_arn = aws_iam_role.ecs_task_role.arn

    # https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ContainerDefinition.html
    container_definitions = jsonencode(local.container_definitions)

    tags = {
        Stage = var.stage_slug
    }
}

# Create ECS Service
resource "aws_ecs_service" "this" {
    name = "${var.stage_slug}-${var.name}"
    cluster = var.ecs_cluster_id
    task_definition = aws_ecs_task_definition.this.arn
    desired_count = var.service_desired_count

    platform_version = "LATEST"

    capacity_provider_strategy {
        capacity_provider = var.fargate_capacity_provider
        weight = 100
    }

    network_configuration {
        security_groups = [
            aws_security_group.this.id
        ]
        subnets = var.service_subnet_ids
        assign_public_ip = true
    }

    dynamic "load_balancer" {
        for_each = var.aws_alb_listener_arn == null ? toset([]) : toset(["main"])
        content {
            target_group_arn = aws_alb_target_group.this["main"].id
            container_name = "${var.stage_slug}-${var.name}"
            container_port = var.task_definition_port_container
        }
    }

    tags = {
        Stage = var.stage_slug
    }
}

# Security groups for access to this service
resource "aws_security_group" "this" {
    name = "${var.stage_slug}-${var.name}"
    vpc_id = var.vpc_id
    description = "[${var.stage_slug}] ECS Service ${var.name}"

    dynamic ingress {
        for_each = var.service_allowed_security_group_ids
        content {
            protocol = "tcp"
            from_port = var.task_definition_port_container
            to_port = var.task_definition_port_container
            security_groups = [
                ingress.value
            ]
        }
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [
            "0.0.0.0/0"
        ]
    }

    tags = {
        Stage = var.stage_slug
    }
}
