/**
* Povio Terraform Queue
* Version 2.0
*/

variable "queue_name" {
    description = "Name of the sqs queue"
    type = string
}

variable "stage_slug" {
    description = "Slug of the stage (environment)"
    type = string
}

variable "sender_arns" {
    description = "ARNs of services that will send to this queue"
    type = list(string)
}

variable "receiver_arns" {
    description = "ARNs of services that will receive from this queue"
    type = list(string)
}

variable "is_fifo" {
    description = "Should queue be FIFO queue"
    type = bool
    default = false
}

variable "visibility_timeout" {
    description = "How long can message be processed before another processor takes over in seconds"
    type = number
    default = 30
}

variable "message_retention" {
    description = "How long can message live in queue in seconds"
    type = number
    default = 345600
}

variable "max_message_size" {
    description = "Max size of message that can go in queue in bytes"
    type = number
    default = 262144
}

variable "delay_seconds" {
    description = "How many seconds should message be delayed before being visible in queue"
    type = number
    default = 0
}

variable "deduplication_scope" {
    description = "Where should deduplication occur"
    type = string
    default = null
}

variable "fifo_throughput_limit" {
    description = "Is throughput for entire queue or message group"
    type = string
    default = null
}

variable "content_based_deduplication" {
    description = "Should SQS attempt to deduplicate messages based on content"
    type = bool
    default = null
}

variable "has_dlq" {
    description = "Will this queue have a dead letter queue"
    type = bool
    default = false
}

variable "dlq_visibility_timeout" {
    description = "How long can message be processed before another processor takes over in DLQ in seconds"
    type = number
    default = 30
}

variable "dlq_message_retention" {
    description = "How long can message live in dead letter queue in seconds"
    type = number
    default = 345600
}

variable "dlq_delay_seconds" {
    description = "How many seconds should message be delayed before being visible in DLQ"
    type = number
    default = 0
}

variable "retry" {
    description = "How many times should message be retried before going to DLQ"
    type = number
    default = 3
}
