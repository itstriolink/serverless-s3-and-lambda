/**
* Povio Terraform PS1
* Version 2.0
*/

resource "aws_cloudfront_distribution" "distribution" {
    # the domains to serve
    aliases = concat(var.aliases, var.cf_aliases)

    comment = "[${var.stage_slug}]  ${concat(var.aliases, var.cf_aliases)[0]} origin"
    enabled = true

    is_ipv6_enabled = true

    #retain_on_delete = false

    # Only serve in US/EU
    price_class = "PriceClass_100"

    # No restrictions for incoming traffic
    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    # Connect to the ALB
    origin {
        domain_name = aws_alb.this.dns_name
        origin_id = "${var.stage_slug}-origin-id"
        custom_origin_config {
            http_port = 80
            https_port = 443
            origin_protocol_policy = "http-only"
            origin_ssl_protocols = [
                "TLSv1.2"
            ]
        }
        #dynamic "custom_header" {
        #  iterator = header
        #for_each = var.cloudfront_origin_custom_headers
        #content {
        #  name  = header.name
        #  value = header.value
        #}
        #}
    }

    # serve static s3 bucket contents
    dynamic "origin" {
        for_each = var.static_endpoints
        content {
            domain_name = origin.value.bucket_regional_domain_name
            origin_id = origin.value.origin_id

            s3_origin_config {
                origin_access_identity = aws_cloudfront_origin_access_identity.s3_static_endpoint[origin.key].cloudfront_access_identity_path
            }
        }
    }

    # serve static s3 bucket contents
    dynamic "ordered_cache_behavior" {
        for_each = var.static_endpoints
        content {
            path_pattern = ordered_cache_behavior.value.path
            allowed_methods = [
                "GET",
                "HEAD",
                "OPTIONS"
            ]
            cached_methods = [
                "GET",
                "HEAD",
                "OPTIONS"
            ]
            target_origin_id = ordered_cache_behavior.value.origin_id

            forwarded_values {
                query_string = false
                headers = [
                    "Origin"
                ]

                cookies {
                    forward = "none"
                }
            }

            min_ttl = 0
            default_ttl = 86400
            max_ttl = 31536000
            compress = true
            viewer_protocol_policy = "redirect-to-https"
        }
    }

    # DISABLE ALL CACHE
    # @see Managed-CachingDisabled
    default_cache_behavior {

        # methods to forward to the server
        allowed_methods = [
            "DELETE",
            "GET",
            "HEAD",
            "OPTIONS",
            "PATCH",
            "POST",
            "PUT"
        ]

        # methods to cache
        #  this is mandatory, cloudfront wont cache them if properly set
        cached_methods = [
            "HEAD",
            "GET"
        ]

        # A unique identifier for the origin
        target_origin_id = "${var.stage_slug}-origin-id"

        # Dont allow HTTP - always redirect to HTTPS
        viewer_protocol_policy = "redirect-to-https"

        # The server should already have this compressed the response
        # compress = false

        # Disable cache on all objects
        default_ttl = 0
        min_ttl = 0
        max_ttl = 0

        forwarded_values {
            cookies {
                forward = "all"
            }
            headers = [
                "*"
            ]
            query_string = true
        }
    }

    # Serve the content with HTTPS
    viewer_certificate {
        acm_certificate_arn = var.cloudfront_certificate_arn
        cloudfront_default_certificate = false
        minimum_protocol_version = "TLSv1.2_2019"
        ssl_support_method = "sni-only"
    }

    tags = {
        Stage = var.stage_slug
    }
}

# serve static s3 bucket contents
resource "aws_cloudfront_origin_access_identity" "s3_static_endpoint" {
    for_each = var.static_endpoints
    comment = "[${var.stage_slug}] LB Static Endpoint ${each.value.origin_id}"
}

data "aws_iam_policy_document" "s3_static_endpoint" {
    for_each = var.static_endpoints

    statement {
        actions = [
            "s3:GetObject"
        ]
        resources = [
            "${each.value.bucket_arn}/*"
        ]

        principals {
            type = "AWS"
            identifiers = [
                aws_cloudfront_origin_access_identity.s3_static_endpoint[each.key].iam_arn
            ]
        }
    }
    statement {
        actions = [
            "s3:ListBucket"
        ]
        resources = [
            each.value.bucket_arn
        ]

        principals {
            type = "AWS"
            identifiers = [
                aws_cloudfront_origin_access_identity.s3_static_endpoint[each.key].iam_arn
            ]
        }
    }
}
resource "aws_s3_bucket_policy" "example" {
    for_each = var.static_endpoints
    bucket = each.value.bucket_id
    policy = data.aws_iam_policy_document.s3_static_endpoint[each.key].json
}

