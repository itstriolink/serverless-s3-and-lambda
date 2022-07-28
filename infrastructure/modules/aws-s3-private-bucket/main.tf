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
resource "aws_s3_bucket_cors_configuration" "bucket_cors_conf" {
  bucket = aws_s3_bucket.origin.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "GET"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
  }
}

resource "aws_s3_bucket_acl" "origin" {
  bucket = aws_s3_bucket.origin.id
  acl    = "private"
}

# Keep old versions
resource "aws_s3_bucket_versioning" "origin" {
  bucket = aws_s3_bucket.origin.id
  versioning_configuration {
    status     = var.enable_versioning ? "Enabled" : "Suspended"
    mfa_delete = var.enable_mfa_delete ? "Enabled" : "Disabled"
  }
}

# faster s3 speed for higher cost
# https://docs.aws.amazon.com/AmazonS3/latest/dev/transfer-acceleration.html
resource "aws_s3_bucket_accelerate_configuration" "origin" {
  bucket = aws_s3_bucket.origin.id
  status = var.acceleration_status
}

resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = aws_s3_bucket.origin.id
  lambda_function {
    lambda_function_arn = var.lambda_arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "uploads/"
  }

  depends_on = [aws_lambda_permission.s3_permission_to_trigger_lambda]
}

resource "aws_lambda_permission" "s3_permission_to_trigger_lambda" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${aws_s3_bucket.origin.id}"
}

