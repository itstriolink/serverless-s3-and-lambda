/**
* Povio Terraform S3
* Version 2.0
*/

variable "bucket_name" {
    description = "Name of the public s3 bucket"
    type = string
}

variable "stage_slug" {
    description = "Slug of the stage (environment)"
    type = string
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

variable "lambda_arn" {
    description = "ARN of Lambda to trigger"
    type = string
}

