/**
* Povio Terraform PS1
* Version 2.0
*/

# create Security Group for load balancer (ALB).
resource "aws_security_group" "public" {
    name = "${var.name}-alb-public"
    description = "Controls incoming access to Load Balancer"
    vpc_id = var.vpc_id

    # allow all inbound traffic for a given port, TCP protocol and any IP
    # todo, limit access to cloudfront
    ingress {
        protocol = "tcp"
        from_port = 80
        to_port = 80
        cidr_blocks = [
            "0.0.0.0/0"
        ]
    }

    # allow all outbound traffic for any port, protocol and IP
    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = [
            "0.0.0.0/0"
        ]
    }

    tags = {
        Stage = var.stage_slug
    }
}
