/**
* Povio Terraform EventBridge
* Version 2.0
*/

variable "stage_slug" {
    description = "Slug of the stage (environment)"
    type = string
}

variable "rules" {
    type = map(object({
        name: string,
        schedule_expression: string,
        input: map(string),
    }))
}

variable "queue_name" {
    description = "Name of the sqs queue"
    type = string
}

variable "queue_receiver_arns" {
    description = "ARN of service that will receive from this queue"
    type = list(string)
}

variable "queue_visibility_timeout" {
    description = "How long can message be processed before another processor takes over in seconds"
    type = number
    default = 30
}

variable "queue_message_retention" {
    description = "How long can message live in queue in seconds"
    type = number
    default = 345600
}

variable "queue_max_message_size" {
    description = "Max size of message that can go in queue in bytes"
    type = number
    default = 262144
}
