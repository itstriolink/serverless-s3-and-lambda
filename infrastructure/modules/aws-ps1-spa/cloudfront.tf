/**
* Povio Terraform PS1
* Version 2.0
*/

# Origin Access Identity for S3 Bucket
resource "aws_cloudfront_origin_access_identity" "origin" {
    comment = "[${var.stage_slug}] S3 Bucket SPA Origin Access Identity"
}

# Cloud Front Distribution
resource "aws_cloudfront_distribution" "origin" {
    aliases = concat(var.aliases, var.cf_aliases)
    comment = "[${var.stage_slug}] ${concat(var.aliases, var.cf_aliases)[0]} origin"
    default_root_object = "index.html"
    enabled = true
    price_class = "PriceClass_100"
    is_ipv6_enabled = true

    origin {
        domain_name = aws_s3_bucket.origin.bucket_regional_domain_name
        origin_id = var.s3_origin_id

        s3_origin_config {
            origin_access_identity = aws_cloudfront_origin_access_identity.origin.cloudfront_access_identity_path
        }
    }

    # default/fallback caching behaviour
    default_cache_behavior {
        # Allowing only GET
        allowed_methods = [
            "GET",
            "HEAD",
            "OPTIONS"
        ]
        cached_methods = [
            "GET",
            "HEAD"
        ]
        target_origin_id = var.s3_origin_id
        viewer_protocol_policy = "redirect-to-https"

        # Caching is enabled
        default_ttl = 3600
        min_ttl = 0
        max_ttl = 86400

        # Don't forward query params and cookies
        forwarded_values {
            query_string = false
            cookies {
                forward = "none"
            }
        }
    }

    # Redirect some of error codes to SPA root object
    dynamic "custom_error_response" {
        for_each = [
            404,
            403
        ]

        content {
            error_code = custom_error_response.value
            response_code = 200
            response_page_path = "/index.html"
        }
    }

    # No restrictions for incoming traffic
    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    viewer_certificate {
        cloudfront_default_certificate = false
        acm_certificate_arn = var.cert_arn
        ssl_support_method = "sni-only"
        # minimum_protocol_version = "TLSv1.1_2016"
    }

    tags = {
        Stage = var.stage_slug
    }
}
