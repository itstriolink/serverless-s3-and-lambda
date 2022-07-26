/**
* Povio Terraform PS1
* Version 2.0
*/

# Common variables for all modules.

variable "stage_slug" {
    description = "Slug of the stage (environment)"
    type = string
}

variable "name" {
    description = "Name of the Repo and Service"
    type = string
}

# Module specific variables.

variable "ecs_cluster_id" {
    description = "ECS Cluster Id"
    type = string
}

variable "ecs_cluster_name" {
    description = "ECS Cluster Name"
    type = string
}

variable "vpc_id" {
    description = "VPC Id"
    type = string
}

variable "task_definition_cpu" {
    description = "The number of cpu units used by the task (256 = 0.256vCPU)"
    type = number
    default = 256
}

variable "task_definition_memory" {
    description = "The amount (in MiB) of memory used by the task"
    type = number
    default = 512
}

variable "task_definition_image" {
    description = "Docker image name/tag"
    type = string
    # make the server display "something"
    default = "nginx:latest"
}

variable "container_environment" {
    description = "Container environment variables"
    type = map(string)
    default = {}
}

variable "container_secrets" {
    description = "Container secret variables"
    type = map(string)
    default = {}
}

variable "merge_existing_container_environment" {
    description = "If the container_environment and container_secrets should merge into the previous definition"
    type = bool
    default = false
}

variable "container_task_ssm_and_secret_arns" {
    description = "Container Task SSM and Secrets ARNS"
    type = list(string)
    default = []
}

variable "container_task_extra_permissions" {
    description = "Container Task Extra IAM permissions"
    type = any
    default = []
}

variable "container_executor_ssm_and_secret_arns" {
    description = "Container Executor SSM and Secrets ARNS"
    type = list(string)
    default = []
}

variable "ssm_kms_key_arn" {
    description = "ARN of KMS Key to decrypt SSM"
    type = string
}

variable "health_check_path" {
    description = "Container health check path"
    type = string
}

variable "target_port" {
    description = "Target group port"
    type = number
    default = 80
}

variable "target_path_patterns" {
    description = "Target group pattern"
    type = list(string)
    default = []
}

variable "target_domains" {
    description = "Target group domains"
    type = list(string)
    default = []
}

variable "task_definition_port_container" {
    description = "Container exposed port (matching application port)"
    type = number
    default = 3000
}

variable "task_definition_awslogs_region" {
    description = "AWS Logs Region"
    type = string
    default = "us-east-1"
}

variable "task_definition_awslogs_stream_prefix" {
    description = "AWS Logs Stream Prefix"
    type = string
    default = "ecs"
}

variable "fargate_capacity_provider" {
    description = "Fargate Capacity Provider"
    type = string
    default = "FARGATE_SPOT"
}

variable "service_desired_count" {
    description = "Desired number of replicated instances of the service"
    type = number
    default = 1
}

variable "service_subnet_ids" {
    description = "List of subnet ids. Commonly private subnets in different AZs"
    type = list(string)
}

variable "service_allowed_security_group_ids" {
    description = "List of security group ids allowed to access this service"
    type = list(string)
}

variable "aws_alb_listener_arn" {
    description = "AWS ALB Listener ARN"
    type = string
    default = null
}

variable "aws_alb_listener_priority" {
    description = "AWS ALB Listener Priority"
    type = number
    default = 100
}

variable "aws_s3_buckets" {
    description = "Buckets this service has access to"
    type = list(string)
    default = []
}

variable "first_run" {
    description = "Does not use existing values for task definitions if set"
    type = bool
}

