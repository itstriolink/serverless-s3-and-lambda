/**
* Povio Terraform S3
* Version 2.0
*/

resource "aws_s3_bucket" "origin" {
    bucket = var.bucket_name

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

resource "aws_s3_bucket_lifecycle_configuration" "origin" {
    count = length(var.lifecycle_rules) == 0 ? 0 : 1
    bucket = aws_s3_bucket.origin.id
    dynamic "rule" {
        for_each = var.lifecycle_rules
        content {
            status = "Enabled"
            id = rule.key
            filter {
                prefix = rule.value.prefix
            }

            dynamic "expiration" {
                for_each = rule.value.type == "expiration" ? ["1"] : []
                content {
                    days = rule.value.days
                    date = rule.value.date
                    expired_object_delete_marker = rule.value.expired_object_delete_marker
                }
            }

            dynamic "transition" {
                for_each = rule.value.type == "transition" ? ["1"] : []
                content {
                    storage_class = rule.value.storage_class
                    days = rule.value.days
                    date = rule.value.date
                }
            }

            abort_incomplete_multipart_upload_days = rule.value.abort_incomplete_multipart_upload_days
        }
    }
}
