/**
* Povio Terraform PS1
* Version 2.0
*/

# configure policies for IAM user
# allowing reading and writing to S3 bucket and creating Cloud Front distribution
resource "aws_iam_policy" "deploy" {
    name = "${var.bucket}-deploy"

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Sid = "CreateCloudFrontDistributionInvalidation",
                Effect = "Allow",
                Action = [
                    "cloudfront:CreateInvalidation"
                ],
                Resource = [
                    aws_cloudfront_distribution.origin.arn
                ]
            },
            {
                Sid = "ListObjectsInBucket",
                Effect = "Allow",
                Action = [
                    "s3:ListBucket"
                ],
                Resource = [
                    aws_s3_bucket.origin.arn
                ]
            },
            {
                Sid = "WriteObjectsInBucket",
                Effect = "Allow",
                Action = [
                    "s3:PutObject",
                    "s3:PutObjectAcl"
                ],
                Resource = [
                    "${aws_s3_bucket.origin.arn}/*"
                ]
            }
        ]
    })

    tags = {
        Stage = var.stage_slug
    }
}
