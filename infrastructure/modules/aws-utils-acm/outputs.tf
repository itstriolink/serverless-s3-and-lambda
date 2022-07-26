/**
* Povio Terraform Utils ACM
* Version 2.0
*/

output "cert_arn" {
    value = aws_acm_certificate.cert.arn
}

output "domain" {
    value = var.hosted_zone
}

output "zone_id" {
    value = var.zone_id
}
