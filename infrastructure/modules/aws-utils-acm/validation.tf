/**
* Povio Terraform Utils ACM
* Version 2.0
*/

# validate certificate association with domain name using DNS records
resource "aws_acm_certificate_validation" "cert" {
    certificate_arn = aws_acm_certificate.cert.arn
    validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]

    lifecycle {
        ignore_changes = all
    }

    provider = aws.virginia
}
