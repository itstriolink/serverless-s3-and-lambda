
resource "random_password" "user_password" {
    length = 30
    special = false
}

resource "aws_ssm_parameter" "user_password" {
    name  = var.database_password_output_ssm_name
    type  = "SecureString"
    value = random_password.user_password.result

    tags = {
        STAGE = var.stage_slug
    }
}

resource "postgresql_role" "user" {
    provider = postgresql.blog
    name            = var.database_user
    password        = random_password.user_password.result
    login           = true
    create_database = "false"
}

resource "postgresql_database" "database" {
    provider = postgresql.blog
    name       = var.database_name
    owner      = var.provider_user
    lc_collate = "en_US.UTF-8"
    lc_ctype   = "en_US.UTF-8"
    encoding   = "UTF8"
}

resource "postgresql_default_privileges" "user_privileges_table" {
    provider = postgresql.blog
    database    = postgresql_database.database.name
    owner       = var.provider_user
    role        = postgresql_role.user.name
    schema      = "public"
    object_type = "table"
    privileges  = ["ALL"]
    depends_on  = [postgresql_database.database, postgresql_role.user]
}

resource "postgresql_default_privileges" "user_privileges_sequence" {
    provider = postgresql.blog
    database    = postgresql_database.database.name
    owner       = var.provider_user
    role        = postgresql_role.user.name
    schema      = "public"
    object_type = "sequence"
    privileges  = ["ALL"]
    depends_on  = [postgresql_database.database, postgresql_role.user, postgresql_role.user]
}

data "aws_secretsmanager_secret_version" "password" {
    secret_id = var.provider_pass_secret_arn
}

# database, needs to be set up with stages/sha/blog-rds
provider "postgresql" {
    alias = "blog"
    scheme = "awspostgres"
    database = "postgres"
    connect_timeout = 15
    superuser = false
    sslmode = "require"

    host     = var.provider_host
    port     = var.provider_port
    username = var.provider_user
    password = data.aws_secretsmanager_secret_version.password.secret_string
}
