/**
* Version 2.0
*/

data "archive_file" "lambda_zip_dir" {
  type        = "zip"
  output_path = "lambda.zip"
  source_dir  = "src"
}

resource "aws_lambda_function" "origin" {
  function_name = "${var.stage_slug}-${var.name}"

  filename         = data.archive_file.lambda_zip_dir.output_path
  source_code_hash = data.archive_file.lambda_zip_dir.output_base64sha256
  handler          = "src/resize.handler"

  runtime = "nodejs14.x"

  memory_size = var.lambda_memory_size

  role = aws_iam_role.lambda_role.arn

  tags = {
    Stage = var.stage_slug
  }
}
