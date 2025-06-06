


data "aws_iam_policy_document" "check_db_trust" {
    statement {
        effect = "Allow"
        principals = {
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


resource "aws_iam_role" "check_db_lambda_role" {
    name = "check_db_lambda_role"
    assume_role_policy = data.aws_iam_policy_document.check_db_trust.json
}


resource "aws_iam_policy" "check_db_lambda_perm" {
    name = "check_db_lambda_perm"
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Actions = [
                    "sns:Publish"
                ]
                Resources = [
                    aws_sns_topic.notify_inactive_ticket.arn
                ]
            }
        ]
    })
}


resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.check_db_lambda_role.name
  policy_arn = aws_iam_policy.check_db_lambda_perm.arn
}


resource "aws_lambda_function" "check_db" {
    filename      = "lambda_function_check_db.zip"
    function_name = "lambda_check_db"
    role          = aws_iam_role.iam_for_lambda.arn
    handler       = "lambda_check_db.handler"

    source_code_hash = filebase64sha256("lambda_function_check_db.zip")

    runtime = "python3.12"


    environment {
        variables = {
        SNS_TOPIC_ARN = aws_sns_topic.notify_inactive_ticket.arn
        }
    }
}

