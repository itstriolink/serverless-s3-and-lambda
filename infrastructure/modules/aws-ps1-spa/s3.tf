/**
* Povio Terraform PS1
* Version 2.0
*/

# S3 Bucket for serving static web content
resource "aws_s3_bucket" "origin" {
    bucket = var.bucket

    # do not allow this bucket to be destroyed
    force_destroy = false

    tags = {
        Stage = var.stage_slug
    }
}

resource "aws_s3_bucket_acl" "origin" {
    bucket = aws_s3_bucket.origin.id
    acl = "private"
}

# SPA support
resource "aws_s3_bucket_website_configuration" "origin" {
    bucket = aws_s3_bucket.origin.id
    index_document {
        suffix = "index.html"
    }

    error_document {
        key = "index.html"
    }
}

# Keep old versions
resource "aws_s3_bucket_versioning" "origin" {
    bucket = aws_s3_bucket.origin.id
    versioning_configuration {
        status = var.enable_versioning ? "Enabled" : "Suspended"
        mfa_delete = var.enable_mfa_delete ? "Enabled" : "Disabled"
    }
}

# faster s3 speed for higher cost
# https://docs.aws.amazon.com/AmazonS3/latest/dev/transfer-acceleration.html
resource "aws_s3_bucket_accelerate_configuration" "origin" {
    bucket = aws_s3_bucket.origin.id
    status = var.acceleration_status
}

# create S3 Bucket Policy to allow CloudFront access
data "aws_iam_policy_document" "origin" {
    statement {
        actions = [
            "s3:GetObject"
        ]

        resources = [
            "${aws_s3_bucket.origin.arn}/*"
        ]

        principals {
            type = "AWS"
            identifiers = [
                aws_cloudfront_origin_access_identity.origin.iam_arn
            ]
        }
    }
}

# Attach S3 Bucket Policy for CloudFront access to bucket
resource "aws_s3_bucket_policy" "origin" {
    bucket = aws_s3_bucket.origin.id
    policy = data.aws_iam_policy_document.origin.json
}
