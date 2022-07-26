/**
* Povio Terraform S3
* Version 2.0
*/

output "bucket_arn" {
    value = aws_s3_bucket.origin.arn
}

output "bucket_id" {
    value = aws_s3_bucket.origin.id
}

output "bucket_regional_domain_name" {
    value = aws_s3_bucket.origin.bucket_regional_domain_name
}

output "bucket_name" {
    value = var.bucket_name
}
