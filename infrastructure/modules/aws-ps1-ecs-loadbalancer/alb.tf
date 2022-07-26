/**
* Povio Terraform PS1
* Version 2.0
*/

#
# Create Application Load Balancer, with listener and security groups.
#

# create Application Load Balancer
resource "aws_alb" "this" {
    name = var.name
    subnets = var.public_subnet_ids
    security_groups = [
        aws_security_group.public.id
    ]
    internal = false
    #load_balancer_type = "application"
    #ip_address_type    = "ipv4"

    tags = {
        Stage = var.stage_slug
        Name = var.name
    }
}

# create Application Load Balancer Listener with default static response
resource "aws_alb_listener" "this" {
    load_balancer_arn = aws_alb.this.id
    port = 80
    protocol = "HTTP"
    # certificate_arn   = var.listener_certificate_arn

    default_action {
        type = "fixed-response"

        fixed_response {
            content_type = "text/plain"
            status_code = "400"
            message_body = "Nothing here!"
        }
    }

    tags = {
        Stage = var.stage_slug
    }
}
