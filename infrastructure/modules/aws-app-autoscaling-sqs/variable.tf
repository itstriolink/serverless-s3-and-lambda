/**
* Povio Terraform SQS App autoscaling
* Version 2.0
*/

# Common variables for all modules.
variable "stage_slug" {
    description = "Slug of the stage (environment)"
    type = string
}

# Module specific variables.
variable "cluster" {
    description = "Name of cluster in which service is located"
    type = string
}

variable "service" {
    description = "Name of service to scale"
    type = string
}

variable "queues" {
    description = "Name of queue by which to scale"
    type = list(string)
}

variable "min_capacity" {
    description = "Min capacity of service"
    type = number
    default = 0

    validation {
        condition = var.min_capacity >= 0
        error_message = "Variable min_capacity must be greater or equal 0."
    }
}

variable "max_capacity" {
    description = "Max capacity of service"
    type = number
    default = 3

    validation {
        condition = var.max_capacity >= 1
        error_message = "Variable max_capacity must be greater or equal 1."
    }
}

variable "up_cooldown" {
    description = "Cooldown between scaling up in seconds"
    type = number
    default = 60
}

variable "down_cooldown" {
    description = "Cooldown between scaling down in seconds"
    type = number
    default = 300
}

variable "scaling_up_adjustment" {
    description = "How many services should be added on scale up"
    type = number
    default = 1
}

variable "scaling_down_adjustment" {
    description = "How many services should be removed on scale down"
    type = number
    default = -1
}

variable "metric_lower_bound" {
    description = "Lower bound for the difference between the alarm threshold and the CloudWatch metric"
    type = number
    default = 0
}

variable "metric_upper_bound" {
    description = "Upper bound for the difference between the alarm threshold and the CloudWatch metric"
    type = number
    default = 0
}
