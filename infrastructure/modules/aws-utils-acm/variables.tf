/**
* Povio Terraform Utils ACM
* Version 2.0
*/

variable "zone_id" {
    type = string
}

variable "hosted_zone" {
    description = "Suffix for the domain *.[hosted_zone]"
    type = string
}

variable "aliases" {
    description = "Additional domains to attach to the certificate"
    type = list(string)
    default = []
}

variable "stage_slug" {
    description = "Slug of the stage (environment)"
    type = string
}

variable "name" {
    description = "Certificate name (no special characters)"
    type = string
}

