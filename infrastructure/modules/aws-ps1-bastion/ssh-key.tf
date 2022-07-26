/**
* Povio Terraform Bastion
* Version 2.0
*/

resource "aws_key_pair" "bastion" {
    key_name   = "${var.stage_slug}-${var.name}"
    public_key = tls_private_key.bastion.public_key_openssh

    tags = {
        Stage = var.stage_slug
    }
}


resource "tls_private_key" "bastion" {
    algorithm = "RSA"
    rsa_bits  = 4096
}
