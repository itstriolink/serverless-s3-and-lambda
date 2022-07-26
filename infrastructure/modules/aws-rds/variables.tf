/**
* Povio Terraform RDS
* Version 2.0
*/

# Common variables for all modules.
variable "stage_slug" {
    description = "Slug of the stage (environment)"
    type = string
}

# Module specific variables.
variable "rds_engine" {
    description = "Type of database (postgres|mysql)"
    type = string
    default = "postgres"
}

# Module specific variables.
variable "rds_name" {
    description = "Name of RDS instance and Security Group"
    type = string
}

variable "rds_port" {
    description = "RDS port"
    type = number
    default = 5432
}

variable "rds_master_username" {
    description = "Master username"
    type = string
    default = "root"
}

variable "rds_database_name" {
    description = "Name of database to be created in RDS"
    type = string
    default = null
}

variable "rds_apply_immediately" {
    description = "Indicates if changes should be applied immediately"
    type = bool
    default = false
}

variable "rds_publicly_accessible" {
    description = "Indicates if changes should be applied immediately"
    type = bool
    default = false
}

variable "rds_ingress_security_groups" {
    description = "Security groups with access"
    type = list(string)
    default = []
}

variable "rds_ingress_ip_ranges" {
    description = "Ip ranges with access"
    type = list(string)
    default = []
}

variable "rds_instance_class" {
    description = "RDS Instance class"
    type = string
    default = "db.t2.micro"
}

variable "rds_encrypted" {
    description = "RDS Storage encrypted"
    type = bool
    default = false
}

variable "rds_deletion_protection" {
    description = "RDS Deletion protection"
    type = bool
    default = false
}

variable "rds_skip_final_snapshot" {
    description = "RDS Skip final snapshot"
    type = bool
    default = true
}

variable "rds_allocated_storage" {
    description = "RDS Allocated Storage"
    type = number
    default = 20
}

variable "rds_storage_type" {
    description = "RDS Storage Type"
    type = string
    default = "gp2"
}

variable "rds_engine_version" {
    description = "RDS Engine Version"
    type = string
    default = "12.5"
}

variable "vpc_id" {
    description = "VPC Id"
    type = string
}

variable "db_subnet_group_subnet_ids" {
    description = "List of subnet ids to be attached to DB Subnet Group"
    type = list(string)
}

variable "rds_backup_retention_period" {
    description = "How long to retain backups"
    type = number
    default = 0
}

variable "rds_maintenance_window" {
    description = "When can maintenance be preformed"
    type = string
    default = ""
}

variable "rds_backup_window" {
    description = "When can backup be preformed"
    type = string
    default = ""
}

variable "rds_multi_az" {
    description = "Should database be multi AZ"
    type = bool
    default = false
}

variable "rds_snapshot_instance_id" {
    description = "Id of RDS instance to restore this DB from"
    type = string
    default = null
}

variable "rds_monitoring_interval" {
    description = "Interval in seconds to collect metrics for Enhanced monitoring (Enables enhanced monitoring)"
    type = number
    default = 0
}

variable "rds_performance_insights_enabled" {
    description = "Should performance insights be enabled"
    type = bool
    default = false
}

variable "rds_performance_insights_retention_period" {
    description = "How long should performance insights be retained in days"
    type = number
    default = 0
}

variable "rds_max_allocated_storage" {
    description = "Should storage autoscaling be enabled and to what size"
    type = number
    default = 0
}
