/**
* Povio Terraform Bastion
* Version 2.0
*/

output "bastion_public_ip" {
    value = aws_instance.bastion.public_ip
}

output "bastion_private_key_pem" {
    value = tls_private_key.bastion.private_key_pem
    sensitive = true
}
