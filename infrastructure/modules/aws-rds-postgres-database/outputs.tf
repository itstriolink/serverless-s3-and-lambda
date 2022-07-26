output "rds_address" {
    description = "RDS connection address (only domain)"
    value = var.provider_host
}

output "rds_database_name" {
    description = "RDS Database Name"
    value = var.database_name
}

output "rds_port" {
    description = "RDS connection port"
    value = var.provider_port
}

output "rds_username" {
    description = "RDS master username"
    value = var.database_user
}

output "rds_master_password_secret_arn" {
    description = "RDS master password SSM ARN"
    value = aws_ssm_parameter.user_password.arn
}
