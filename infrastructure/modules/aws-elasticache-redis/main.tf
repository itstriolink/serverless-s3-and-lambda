/**
* Povio Terraform Redis
* Version 2.0
*/

# create ElastiCache Subnet Group - placement in private/restricted subnet
resource "aws_elasticache_subnet_group" "this" {
    name = "${var.elasticache_name}-elasticache"
    subnet_ids = var.elasticache_subnet_group_subnet_ids

    tags = {
        Stage = var.stage_slug
    }
}

resource "aws_elasticache_replication_group" "this" {
    num_cache_clusters = 1
    subnet_group_name = aws_elasticache_subnet_group.this.name
    replication_group_id = var.elasticache_name
    description = "${var.stage_slug} redis"
    engine = "redis"
    port = var.elasticache_port
    apply_immediately = var.elasticache_apply_immediately
    engine_version = var.elasticache_engine_version
    node_type = var.elasticache_instance_class
    security_group_ids = [
        aws_security_group.this.id
    ]
    transit_encryption_enabled = true
    auth_token = random_password.this.result
    
    tags = {
        Stage = var.stage_slug
    }
}
