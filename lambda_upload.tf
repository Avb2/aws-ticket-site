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
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "dynamodb:PutItem",
            ]
            Effect   = "Allow"
            Resource = aws_dynamodb_table.ticket_table.arn
        },
        ]
    })

}





resource "aws_lambda_function" "create_ticket_lambda" {
  filename         = "create_ticket_lambda.zip"
  function_name    = "create_ticket_lambda"
  handler          = "create_ticket_lambda.handler"
  role             = aws_iam_role.dynamo_post_role.arn
  source_code_hash = filebase64sha256("create_ticket_lambda.zip")
  runtime          = "python3.12"
}
