/**
* Povio Terraform Utils ACM
* Version 2.0
*/

# route53 dns record for certificate validation
resource "aws_route53_record" "cert_validation" {
    for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
        name = dvo.resource_record_name
        record = dvo.resource_record_value
        type = dvo.resource_record_type
    }
    }

    allow_overwrite = true
    name = each.value.name
    records = [
        each.value.record
    ]
    ttl = 60
    type = each.value.type
    zone_id = var.zone_id

    provider = aws.virginia
}
