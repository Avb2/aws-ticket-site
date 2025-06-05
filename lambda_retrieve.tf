
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "lambda_dynamo_policy" {
  name = "lambda-dynamo-policy"
  role = aws_iam_role.iam_for_lambda.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "dynamodb:GetItem", 
        "dynamodb:Query", 
        "dynamodb:Scan"
      ],
      Resource = aws_dynamodb_table.ticket_table.arn
    }]
  })
}

data "archive_file" "lambda_archive" {
  type        = "zip"
  source_file = "get_ticket_lambda.py"
  output_path = "retrieve_lambda.zip"
}

resource "aws_lambda_function" "get_ticket_lambda" {
    filename = "retrieve_lambda.zip"
    function_name = "get_ticket_lambda"
    handler = "get_ticket_lambda.handler"
    role          = aws_iam_role.iam_for_lambda.arn
    source_code_hash = data.archive_file.lambda_archive.output_base64sha256

    runtime = "python3.12"
}





