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

variable "lifecycle_rules" {
    description = "Lifecycle rules you want to implement"
    type = map(
        object({
            type = string
            days = optional(number)
            abort_incomplete_multipart_upload_days = optional(number)
            date = optional(string)
            expired_object_delete_marker = optional(bool)
            storage_class = optional(string)
            prefix = optional(string)
        })
    )
    default = {}
}
