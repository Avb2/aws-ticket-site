
resource "aws_lambda_function" "resolve_lambda"{
    filename         = "lambda_resolve_ticket.zip"
    function_name    = "resolve_ticket"
    role             = aws_iam_role.resolve_role.arn
    handler          = "resolve_ticket.handler"
    source_code_hash = filebase64sha256("lambda_resolve_ticket.zip")
    runtime          = "python3.12"
}

data "aws_iam_policy_document" "resolve_trust" {

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


resource "aws_iam_role" "resolve_role" {
    name = "resolve_policy_role"
    assume_role_policy = data.aws_iam_policy_document.resolve_trust.json
}



resource "aws_iam_role_policy" "resolve_perms" {
    name = "resolve_perms"
    role = aws_iam_role.resolve_role.id

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect= "Allow",
                Action = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents",
                    "dynamodb:UpdateItem"
                ],
                Resource = aws_dynamodb_table.ticket_table.arn
            }
        ]
    })
}


