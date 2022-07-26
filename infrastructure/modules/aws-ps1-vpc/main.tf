/**
* Povio Terraform VPC
* Version 2.0
*/

#
# VPC topology with private and public subnets.
#

# Create VPC
resource "aws_vpc" "this" {
    cidr_block = var.aws_vpc_cidr_block

    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Stage = var.stage_slug
        Name = var.aws_vpc_name
    }
}

# Fetch availability zones in the current region
data "aws_availability_zones" "available" {}
