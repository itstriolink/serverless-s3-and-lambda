/**
* Povio Terraform PDF maker API GW
* Version 2.0
*/

output "url" {
    value = aws_api_gateway_deployment.apideploy.invoke_url
}

output "secret" {
    value = random_password.pdf_maker.result
    sensitive = true
}
