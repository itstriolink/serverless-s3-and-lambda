/**
* Povio Terraform PS1
* Version 2.0
*/

# create ECS cluster
resource "aws_ecs_cluster" "this" {
    name = var.name

    tags = {
        Stage = var.stage_slug
    }
}
