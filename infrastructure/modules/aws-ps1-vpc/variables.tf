/**
* Povio Terraform PS1
* Version 1.0
*/

# Common variables for all modules.
variable "stage_slug" { 
    description = "Slug of the stage (environment)"
    type = string
}

# Module specific variables
variable "aws_vpc_name" {
    description = "VPC name"
    type = string
}

variable "aws_vpc_enable_private_subnet" {
    description = "Enable private subnet and Nat gateway"
    type = bool
    default = false
}

variable "aws_vpc_az_count" {
    description = "Number of active Availability Zones. Has effect in subdomain resource"
    type = number
}

variable "aws_vpc_cidr_block" {
    # https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html
    description = "VPC CIDR block"
    type = string
}
