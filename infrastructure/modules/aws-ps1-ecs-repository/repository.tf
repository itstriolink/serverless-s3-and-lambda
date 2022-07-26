/**
* Povio Terraform PS1
* Version 2.0
*/

#
# Create ECR repository with lifecycle policy.
#

# create Docker image holding repository
resource "aws_ecr_repository" "this" {
    name = var.name

    tags = {
        Name = var.name
    }
}

# create repository lifecycle policy (automatic image removal)
resource "aws_ecr_lifecycle_policy" "this" {
    repository = aws_ecr_repository.this.name

    policy = jsonencode({
        rules = [
            {
                rulePriority = 1,
                description = "Expire untagged images older than 7 days",
                selection = {
                    tagStatus = "untagged",
                    countType = "sinceImagePushed",
                    countUnit = "days",
                    countNumber = 7
                },
                action = {
                    type = "expire"
                }
            }
        ]
    })
}
