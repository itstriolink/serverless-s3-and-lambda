/**
* Povio Terraform PDF maker API GW
* Version 2.0
*/

# Common variables for all modules.

variable "stage_slug" {
    description = "Stage slug"
    type = string
}

# Lambda specific variables

variable "name" {
    description = "Lambda name"
    type = string
    default = "pdfmaker"
}

variable "lambda_memory_size" {
    description = "Lambda memory size"
    type = number
    default = 512
}

variable "region" {
    description = "Deploy region"
    type = string
    default = "us-east-1"
}
