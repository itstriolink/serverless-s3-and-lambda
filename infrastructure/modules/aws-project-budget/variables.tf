variable "budget_name" {
    description = "Budget name as shown in AWS console."
    type = string
}

variable "budget_notification_adresses" {
    description = "List of email addresses that will receive budget notifications."
    type = list(string)
    default = []
}

variable "budget_notification_threshold_type" {
    description = "Notification threshold type that determines if threshold represents a relative (percentage) or an absolute value."
    type = string
    default = "PERCENTAGE"

    validation {
        condition = contains(["PERCENTAGE", "ABSOLUTE_VALUE"], var.budget_notification_threshold_type)
        error_message = "The budget notification threshold type is not valid."
    }
}

variable "budget_notification_threshold" {
    description = "Notification threshold that will trigger budget notification, based on [budget_notification_threshold_type]."
    type = number
    default = 80
}

variable "budget_unit" {
    description = "Budget monetary unit, defaults to USD."
    type = string
    default = "USD"
}

variable "budget_amount" {
    description = "Budget amount, defaults to 100."
    type = string
    default = "100"
}

variable "budget_time_period_start" {
    description = "The start of the time period covered by the budget."
    type = string
    default = "2021-07-01_00:00"
}
