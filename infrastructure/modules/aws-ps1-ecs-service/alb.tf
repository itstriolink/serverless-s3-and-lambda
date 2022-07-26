/**
* Povio Terraform PS1
* Version 2.0
*/

# ALB Target Group
resource "aws_alb_target_group" "this" {
    for_each = var.aws_alb_listener_arn == null ? toset([]) : toset(["main"])

    name = "${var.stage_slug}-${var.name}"
    port = var.target_port
    protocol = "HTTP"
    vpc_id = var.vpc_id
    # todo, move to instance
    target_type = "ip"

    health_check {
        port = 80
        path = var.health_check_path
    }

    tags = {
        Stage = var.stage_slug
    }
}


# add forwarding rule to target group to existing listener
resource "aws_lb_listener_rule" "this" {
    for_each = var.aws_alb_listener_arn == null ? toset([]) : toset(["main"])

    listener_arn = var.aws_alb_listener_arn
    priority = var.aws_alb_listener_priority

    action {
        type = "forward"
        target_group_arn = aws_alb_target_group.this["main"].arn
    }

    dynamic "condition" {
        for_each = length(var.target_path_patterns) > 0 ? [
            "enabled"
        ] : []
        content {
            path_pattern {
                values = var.target_path_patterns
            }
        }
    }

    dynamic "condition" {
        for_each = length(var.target_domains) > 0 ? [
            "enabled"
        ] : []
        content {
            host_header {
                values = var.target_domains
            }
        }
    }

    tags = {
        Stage = var.stage_slug
    }
}
