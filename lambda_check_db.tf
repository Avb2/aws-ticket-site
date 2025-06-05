

data "archive_file" "check_lambda"{
    type        = "zip"
    source_file = "lambda_check_db.py"
    output_path = "lambda_function_check_db.zip"
}


resource "aws_lambda_function" "check_db" {
    filename      = "lambda_function_check_db.zip"
    function_name = "lambda_check_db"
    role          = aws_iam_role.iam_for_lambda.arn
    handler       = "lambda_check_db.handler"

    source_code_hash = data.archive_file.check_lambda.output_base64sha256

    runtime = "python3.12"
}