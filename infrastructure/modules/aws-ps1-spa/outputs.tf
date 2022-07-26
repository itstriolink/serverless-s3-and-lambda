/**
* Povio Terraform PS1
* Version 2.0
*/

output "domain_name" {
    description = "CloudFront Distribution Domain Name"
    value = aws_cloudfront_distribution.origin.domain_name
}

output "zone_id" {
    description = "CloudFront Distribution Hosted Zone Id"
    value = aws_cloudfront_distribution.origin.hosted_zone_id
}

output "distribution_arn" {
    description = "CloudFront Distribution ARN"
    value = aws_cloudfront_distribution.origin.arn
}

output "distribution_id" {
    description = "CloudFront Distribution Id"
    value = aws_cloudfront_distribution.origin.id
}

output "bucket_name" {
    description = "Name of the bucket to deploy to"
    value = aws_s3_bucket.origin.bucket
}

output "spa_deploy_policy_name" {
    value = aws_iam_policy.deploy.name
}
