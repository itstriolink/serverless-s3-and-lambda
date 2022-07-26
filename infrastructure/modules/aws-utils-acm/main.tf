/**
* Povio Terraform Utils ACM
* Version 2.0
*/

# Create a certificate for a domain, its subdomains and any aliases for a Zone
# ACM public certificate for the domain and subdomains
resource "aws_acm_certificate" "cert" {
    # define all subdomains
    domain_name = var.hosted_zone

    # define the domain and aliases if given
    subject_alternative_names = concat(
        [
            "*.${var.hosted_zone}"
        ],
        var.aliases
    )

    # use DNS validation (see below)
    validation_method = "DNS"

    lifecycle {
        create_before_destroy = true
    }

    tags = {
        Stage = var.stage_slug
        Name = var.name
    }

    provider = aws.virginia
}
