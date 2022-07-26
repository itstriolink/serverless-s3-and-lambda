/**
* Povio Terraform AWS budget
* Version 2.0
*/

output "aws_project_budget_arn" {
    description = "ARN of the TF managed AWS budget"
    value = aws_budgets_budget.cost.arn
}
