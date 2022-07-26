/**
* Povio Terraform PS1
* Version 2.0
*/

# Common variables for all modules.

variable "stage_slug" {
    description = "Slug of the stage (environment)"
    type = string
}

# Module specific variables.

variable "vpc_id" {
    description = "Existing VPC Id. Used to create Security Group"
    type = string
}

variable "zone_id" {
    description = "VPC Zone ID"
    type = string
}

variable "aliases" {
    description = "Load balancer Cloudfront domains (DNS setup)"
    type = list(string)
    default = []
}

variable "cf_aliases" {
    description = "List of extra domains for CloudFront"
    type = list(string)
    default = []
}

variable "name" {
    description = "Name of application load balancer, cluster, and cloudfront"
    type = string
}

variable "cloudfront_certificate_arn" {
    description = "Cloudfront Certificate ARN"
    type = string
}

variable "public_subnet_ids" {
    description = "List of public subnet ids to attach on security group"
    type = list(string)
}

variable "static_endpoints" {
    description = "List of buckets to serve from their subdirectories"
    type = any
    default = {}
}
