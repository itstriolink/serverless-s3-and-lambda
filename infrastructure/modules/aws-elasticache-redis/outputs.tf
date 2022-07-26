/**
* Povio Terraform Redis
* Version 2.0
*/

output "elasticache_endpoint" {
    description = "ElastiCache connection endpoint"
    value = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "elasticache_port" {
    description = "ElastiCache connection port"
    value = aws_elasticache_replication_group.this.port
}

output "elasticache_password_ssm" {
    description = "ElastiCache password"
    value = aws_ssm_parameter.this.arn
}
