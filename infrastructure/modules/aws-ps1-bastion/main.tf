/**
* Povio Terraform Bastion
* Version 2.0
*/

resource "aws_instance" "bastion" {
    ami                         = var.ami_id
    key_name                    = aws_key_pair.bastion.key_name
    instance_type               = var.instance_type
    vpc_security_group_ids = [
        aws_security_group.bastion.id
    ]
    associate_public_ip_address = true
    subnet_id = var.subnet_id

    root_block_device {
        delete_on_termination = true
    }

    tags = {
        Stage = var.stage_slug
        Name = "${var.stage_slug}-${var.name}"
    }
}
