/**
* Povio Terraform RDS
* Version 2.0
*/

#
# Create RDS Database in VPC with security group.
#

resource "aws_db_instance" "this" {
    identifier = var.rds_name
    db_name = var.rds_snapshot_instance_id == null ? var.rds_database_name : null
    snapshot_identifier = var.rds_snapshot_instance_id == null ? null : aws_db_snapshot.this[0].id
    allocated_storage = var.rds_allocated_storage
    max_allocated_storage = var.rds_max_allocated_storage
    storage_type = var.rds_storage_type
    engine = var.rds_engine
    port = var.rds_port
    engine_version = var.rds_engine_version
    instance_class = var.rds_instance_class
    username = var.rds_snapshot_instance_id == null ? var.rds_master_username : null
    password = random_password.this.result
    storage_encrypted = var.rds_encrypted
    deletion_protection = var.rds_deletion_protection
    skip_final_snapshot = var.rds_skip_final_snapshot
    final_snapshot_identifier = "${var.rds_name}-final-snapshot"
    db_subnet_group_name = aws_db_subnet_group.this.name
    apply_immediately = var.rds_apply_immediately
    publicly_accessible = var.rds_publicly_accessible
    vpc_security_group_ids = [
        aws_security_group.this.id
    ]
    multi_az = var.rds_multi_az
    backup_retention_period = var.rds_backup_retention_period
    maintenance_window = var.rds_maintenance_window
    backup_window = var.rds_backup_window
    monitoring_interval = var.rds_monitoring_interval
    monitoring_role_arn = var.rds_monitoring_interval <= 0 ? null : aws_iam_role.this[0].arn
    performance_insights_enabled = var.rds_performance_insights_enabled
    performance_insights_retention_period = var.rds_performance_insights_retention_period

    tags = {
        Stage = var.stage_slug
    }
}
