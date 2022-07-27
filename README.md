# Terraform + Serverl

Description
------
A development and infrastructure solution for uploading images to S3 and having a Lambda function resize those images accordingly.

The S3 bucket for uploads and the lambda are deployed using Terraform, while the other lambdas (made HTTP accessible through API gateway) are deployed using the Serverless framework. Whenever an image is uploaded into the desired bucket under the `/uploads` directory, it will trigger a lambda which will resize that picture into multiple sizes and re-upload it into the same bucket (under `/images`)

Author
------

Solution is written by [Labian Gashi](https://gitlab.com/labiangashi).

Feedback is welcome.
