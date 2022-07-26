/**
* Povio Terraform PS1
* Version 2.0
*/

output "security_group_public_id" {
    description = "Id of security group controlling access to load balancer"
    value = aws_security_group.public.id
}

output "load_balancer_dns_name" {
    description = "Dns name"
    value = aws_alb.this.dns_name
}

output "load_balancer_zone_id" {
    description = "Zone Id"
    value = aws_alb.this.zone_id
}


output "load_balancer_arn" {
    description = "ARN of load balancer"
    value = aws_alb.this.arn
}

output "load_balancer_id" {
    description = "Id of Load Balancer"
    value = aws_alb.this.id
}

output "load_balancer_listener_arn" {
    description = "Load balancer listener ARN"
    value = aws_alb_listener.this.arn
}

output "cluster_id" {
    description = "ECR Cluster Id"
    value = aws_ecs_cluster.this.id
}

output "cluster_name" {
    description = "ECR Cluster Name"
    value = aws_ecs_cluster.this.name
}
