data "aws_iam_policy_document" "lambda_upload_trust" {
    statement {
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = [
                "lambda.amazonaws.com"
            ]
        }
        actions = [
            "sts:AssumeRole"
        ]
        
    }
}


resource "aws_iam_role" "dynamo_post_role" {
    name = "dynamo_post_role"
    assume_role_policy = data.aws_iam_policy_document.lambda_upload_trust.json
}

resource "aws_iam_role_policy" "dynamo_post_perms" {
    name = "dynamo_post_perms"
    role = aws_iam_role.dynamo_post_role.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Action = [
            "dynamodb:PutItem",
            ]
            Effect   = "Allow"
            Resource = aws_dynamodb_table.ticket_table.arn
        },
        ]
    })

}




data "archive_file" "create_lambda_archive" {
  type        = "zip"
  source_file = "create_ticket_lambda.py"
  output_path = "create_ticket_lambda.zip"
}

resource "aws_lambda_function" "create_ticket_lambda" {
  filename         = "create_ticket_lambda.zip"
  function_name    = "create_ticket_lambda"
  handler          = "create_ticket_lambda.handler"
  role             = aws_iam_role.dynamo_post_role.arn
  source_code_hash = data.archive_file.create_lambda_archive.output_base64sha256
  runtime          = "python3.12"
}