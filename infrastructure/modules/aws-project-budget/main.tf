/**
* Povio Terraform AWS budget module.
* Version 2.0
*/

resource "aws_budgets_budget" "cost" {
    name         = "${var.budget_name}-monthly-budget"
    budget_type  = "COST"
    limit_amount = "${var.budget_amount}"
    limit_unit   = "${var.budget_unit}"
    time_period_start = "${var.budget_time_period_start}"
    time_unit    = "MONTHLY"

    notification {
        comparison_operator        = "GREATER_THAN"
        threshold                  = var.budget_notification_threshold
        threshold_type             = var.budget_notification_threshold_type
        notification_type          = "ACTUAL"
        subscriber_email_addresses = var.budget_notification_adresses
    }
}

