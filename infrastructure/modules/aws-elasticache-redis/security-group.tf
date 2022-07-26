/**
* Povio Terraform Redis
* Version 2.0
*/

# create Security Group for ElastiCache
resource "aws_security_group" "this" {
    name = "${var.elasticache_name}-elasticache"
    vpc_id = var.vpc_id

    # description can not be updated, needs to be non-zero length
    #description = "${var.rds_name}-rds"

    dynamic ingress {
        for_each = var.elasticache_ingress_security_groups
        content {
            protocol = "tcp"
            from_port = var.elasticache_port
            to_port = var.elasticache_port
            security_groups = [ingress.value]
        }
    }

    dynamic ingress {
        for_each = var.elasticache_ingress_ip_ranges
        content {
            protocol = "tcp"
            from_port = var.elasticache_port
            to_port = var.elasticache_port
            cidr_blocks = [ingress.value]
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
