/**
* Povio Terraform PS1
* Version 2.0
*/

# dns record for main domain
resource "aws_route53_record" "origin" {
    for_each = toset(var.aliases)
    zone_id = var.zone_id
    name = each.value
    type = "A"

    alias {
        evaluate_target_health = false
        name = aws_cloudfront_distribution.distribution.domain_name
        zone_id = aws_cloudfront_distribution.distribution.hosted_zone_id
    }
}
