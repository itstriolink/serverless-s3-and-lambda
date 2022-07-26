/**
* Povio Terraform RDS
* Version 2.0
*/

# create secret in AWS Secret Manager
resource "aws_secretsmanager_secret" "this" {
    name_prefix = "${var.rds_name}-rds-master"

    tags = {
        Stage = var.stage_slug
    }
}

# generate master password
resource "random_password" "this" {
    length = 30
    special = false
}

# set secret value
resource "aws_secretsmanager_secret_version" "this" {
    secret_id = aws_secretsmanager_secret.this.id
    secret_string = random_password.this.result
}
