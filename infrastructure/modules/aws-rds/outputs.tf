/**
* Povio Terraform RDS
* Version 2.0
*/

output "rds_endpoint" {
    description = "RDS connection endpoint (with port)"
    value = aws_db_instance.this.endpoint
}

output "rds_address" {
    description = "RDS connection address (only domain)"
    value = aws_db_instance.this.address
}

output "rds_database_name" {
    description = "RDS Database Name"
    value = aws_db_instance.this.name
}

output "rds_port" {
    description = "RDS connection port"
    value = aws_db_instance.this.port
}

output "rds_username" {
    description = "RDS master username"
    value = aws_db_instance.this.username
    sensitive = true
}

output "rds_master_password_secret_arn" {
    description = "RDS master password ARN (from Secret Manager)"
    value = aws_secretsmanager_secret_version.this.arn
}
