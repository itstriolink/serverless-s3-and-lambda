/**
* Povio Terraform PDF maker API GW
* Version 2.0
*/

# Secret for accessing the service
resource "random_password" "pdf_maker" {
    length = 30
    special = false
}
