
variable "stage_slug" {
    description = "Slug of the stage (environment)"
    type = string
}

variable "provider_host" {
    type = string
}

variable "provider_port" {
    type = string
    default = 5432
}

variable "provider_user" {
    type = string
    default = "root"
}

variable "provider_pass_secret_arn" {
    type = string
}

variable "database_name" {
    type = string
}

variable "database_user" {
    type = string
}

variable "database_password_output_ssm_name" {
    description = "The SSM parameter to generate"
    type = string
}
