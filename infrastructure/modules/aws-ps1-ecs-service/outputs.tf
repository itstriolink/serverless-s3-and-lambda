/**
* Povio Terraform PS1
* Version 2.0
*/

output "alb_target_group_arn" {
    description = "ALB Target Group ARN"
    value = var.aws_alb_listener_arn == null ? null : aws_alb_target_group.this["main"].arn
}

output "service_port" {
    description = "Service port"
    value = var.target_port
}

output "ecs_task_execution_iam_role_arn" {
    description = "Service Role ARN"
    value = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_iam_role_arn" {
    description = "Service Role ARN"
    value = aws_iam_role.ecs_task_role.arn
}

output "security_group_id" {
    value = aws_security_group.this.id
}

output "ecs_service_name" {
    description = "Service name"
    value = aws_ecs_service.this.name
}

output "ecs_service_desired_count" {
    description = "Starting desired count for service"
    value = aws_ecs_service.this.desired_count
}

output "ecs_deploy_policy_name" {
    value = aws_iam_policy.deploy_ecs_access.name
}
