/**
* Povio Terraform PS1
* Version 2.0
*/

variable "stage_slug" {
    description = "Slug of the stage (environment)"
    type = string
}

variable "bucket" {
    description = "S3 Bucket to store the SPA"
    type = string
}

variable "zone_id" {
    description = "Route 53 Zone ID"
    type = string
}

variable "cert_arn" {
    description = "ACM Cert ARN for the SPA Domain"
    type = string
}

variable "s3_origin_id" {
    description = "S3 Origin ID"
    type = string
}

variable "aliases" {
    description = "List of extra domains for CloudFront (will create DNS)"
    type = list(string)
    default = []
}

variable "cf_aliases" {
    description = "List of extra domains for CloudFront"
    type = list(string)
    default = []
}

variable "enable_versioning" {
    description = "Should versioning be enabled in bucket"
    type = bool
    default = false
}

variable "enable_mfa_delete" {
    description = "Should multi factor delete be enabled in bucket"
    type = bool
    default = false
}

variable "acceleration_status" {
    description = "Should acceleration be enabled"
    type = string
    default = "Suspended"
}
