/**
* Povio Terraform PS1
* Version 2.0
*/

output "repository_id" {
    description = "ECR repository Id"
    value = aws_ecr_repository.this.id
}

output "repository_url" {
    description = "ECR repository Url"
    value = aws_ecr_repository.this.repository_url
}

output "repository_name" {
    description = "ECR repository Name"
    value = var.name
}

output "ecr_push_policy_name" {
    value = aws_iam_policy.push_image.name
}
