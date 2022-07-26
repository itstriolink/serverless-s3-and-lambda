/**
* Povio Terraform Redis
* Version 2.0
*/

# generate master password
resource "random_password" "this" {
    length = 30
    special = false
}

resource "aws_ssm_parameter" "this" {
    name  = "/${var.stage_slug}/redis/password"
    type  = "SecureString"
    value = random_password.this.result
    
    tags = {
        Stage = var.stage_slug
    }
}
