/**
* Povio Terraform Bastion
* Version 2.0
*/

variable "vpc_id" {
    description = "VPC Id"
    type = string
}

variable "subnet_id" {
    description = "Subnet ID"
    type = string
}

variable "stage_slug" {
    description = "Slug of the stage (environment)"
    type = string
}

variable "ami_id" {
    description = "ID of AMI you want to use"
    type = string
    default = "ami-052efd3df9dad4825" # ubuntu 22.04 LTS (us-east-1)
}

variable "instance_type" {
    description = "Type of instance you want your AMI to work with"
    type = string
    default = "t3.micro"
}

variable "name" {
    description = "Name of host"
    type = string
    default = "bastion"
}
