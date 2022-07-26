/**
* Povio Terraform Redis
* Version 2.0
*/

# Common variables for all modules.
variable "stage_slug" {
    description = "Slug of the stage (environment)"
    type = string
}

# Module specific variables.
variable "elasticache_name" {
    description = "Name of ElastiCache instance and Security Group"
    type = string
}

variable "elasticache_port" {
    description = "ElastiCache port"
    type = number
    default = 6379
}

variable "elasticache_apply_immediately" {
    description = "Indicates if changes should be applied immediately"
    type = bool
    default = false
}

variable "elasticache_ingress_security_groups" {
    description = "Security groups with access"
    type = list(string)
    default = []
}

variable "elasticache_ingress_ip_ranges" {
    description = "Ip ranges with access"
    type = list(string)
    default = []
}

variable "elasticache_instance_class" {
    description = "RDS Instance class"
    type = string
    default = "cache.t2.micro"
}

variable "elasticache_engine_version" {
    description = "ElastiCache Engine Version"
    type = string
    default = "6.x"
}

variable "vpc_id" {
    description = "VPC Id"
    type = string
}

variable "elasticache_subnet_group_subnet_ids" {
    description = "List of subnet ids to be attached to ElastiCache Subnet Group"
    type = list(string)
}
