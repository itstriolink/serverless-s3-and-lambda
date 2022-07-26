/**
* Povio Terraform PS1
* Version 2.0
*/

# create DNS record for alias domains
resource "aws_route53_record" "aliases" {
    for_each = toset(var.aliases)

    zone_id = var.zone_id
    name = each.value
    type = "A"

    alias {
        evaluate_target_health = false
        name = aws_cloudfront_distribution.origin.domain_name
        zone_id = aws_cloudfront_distribution.origin.hosted_zone_id
    }
}
