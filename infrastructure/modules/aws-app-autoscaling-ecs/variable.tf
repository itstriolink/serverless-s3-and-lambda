/**
* Povio Terraform App autoscaling
* Version 2.0
*/

# Common variables for all modules.
variable "stage_slug" {
    description = "Slug of the stage (environment)"
    type = string
}

# Module specific variables.
variable "services" {
    description = "Services you want to create alarms for"
    type = map(
        object(
            {
                cluster: string
                service: string
                min_capacity: number
                max_capacity: number
                up_cooldown: number
                down_cooldown: number
                metric_lower_bound: number
                metric_upper_bound: number
                scaling_up_adjustment: number
                scaling_down_adjustment: number
            }
        )
    )
}

variable "scale_up_alarms" {
    description = "Alarms you want to create for scaling up"
    type = map(
        object(
            {
                service_key: string
                operator: string
                evaluation_periods: number
                metric_name: string
                period: number
                threshold: number
                datapoints: number
                statistic: string
            }
        )
    )
}

variable "scale_down_alarms" {
    description = "Alarms you want to create for scaling down"
    type = map(
        object(
            {
                service_key: string
                operator: string
                evaluation_periods: number
                metric_name: string
                period: number
                threshold: number
                datapoints: number
                statistic: string
            }
        )
    )
}
