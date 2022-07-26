terraform {
    required_providers {
        mysql = {
            source = "winebarrel/mysql"
            version = "1.10.6"
        }
    }
}


resource "random_password" "user_password" {
    length = 30
    special = false
}

resource "aws_ssm_parameter" "user_password" {
    name = var.database_password_output_ssm_name
    type = "SecureString"
    value = random_password.user_password.result

    tags = {
        STAGE = var.stage_slug
    }
}

resource "mysql_user" "user" {
    provider = mysql.blog
    user = var.database_user
    plaintext_password = random_password.user_password.result
}

resource "mysql_database" "database" {
    provider = mysql.blog
    name = var.database_name
}

resource "mysql_grant" "user" {
    provider = mysql.blog
    user       = mysql_user.user.user
    host       = mysql_user.user.host
    database   = var.database_name
    privileges = ["ALL"]
}

data "aws_secretsmanager_secret_version" "password" {
    secret_id = var.provider_pass_secret_arn
}

# database, needs to be set up with stages/sha/blog-rds
provider "mysql" {
    alias = "blog"

    endpoint = "${var.provider_host}:${var.provider_port}"
    username = var.provider_user
    password = data.aws_secretsmanager_secret_version.password.secret_string
}
