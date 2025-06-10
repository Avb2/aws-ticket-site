

data "aws_iam_policy_document" "assign_lambda_trust"{

    statement {
        effect = "Allow"
        principals {
            type = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }
        actions = ["sts:AssumeRole"]
    }
}


resource "aws_iam_role" "allow_user_cognito" {
    name = "allow_user_cognito"
    assume_role_policy = data.aws_iam_policy_document.assign_lambda_trust.json

}


resource "aws_iam_role_policy" "assign_lamba_perms" {
    name = "assign_lamba_perms"
    role = aws_iam_role.allow_user_cognito.name

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{
             Action = [
                "cognito-idp:AdminAddUserToGroup"
            ]
            Effect   = "Allow"
            Resource = "*"
        }]
    })
}





resource "aws_lambda_function" "assign_user_lambda" {
    filename      = "lambda_function_assign_user.zip"
    function_name = "lambda_assign_user"
    role          = aws_iam_role.allow_user_cognito.arn
    handler       = "lambda_assign_user.handler"

    source_code_hash = filebase64sha256("lambda_function_assign_user.zip")

    runtime = "python3.12"


    environment {
        variables = {
        SNS_TOPIC_ARN = "arn:aws:sns:us-east-2:897729097986:sns_mfa"
        }
  }
}