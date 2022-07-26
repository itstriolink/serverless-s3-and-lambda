/**
* Povio Terraform PDF maker API GW
* Version 2.0
*/

resource "aws_lambda_function" "pdf_maker" {
    function_name  = "${var.stage_slug}-${var.name}"

    filename = "pdfmaker.zip"
    source_code_hash = filebase64sha256("pdfmaker.zip")
    handler        = "pdfmaker.handler"

    runtime = "nodejs14.x"

    layers = [
        // Prebuilt Chrome and Puppeteer Layer
        // https://github.com/shelfio/chrome-aws-lambda-layer
        "arn:aws:lambda:${var.region}:764866452798:layer:chrome-aws-lambda:31"
    ]

    memory_size   = var.lambda_memory_size

    environment {
        variables = {
            SECRET = random_password.pdf_maker.result
        }
    }

    role = aws_iam_role.lambda_role.arn
    
    tags = {
        Stage = var.stage_slug
    }
}
