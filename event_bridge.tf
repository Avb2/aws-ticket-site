data "aws_iam_policy_document" "scheduler_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["scheduler.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "scheduler_invoke_lambda" {
  statement {
    effect = "Allow"
    actions = ["lambda:InvokeFunction"]
    resources = [aws_lambda_function.check_db.arn]
  }
}

resource "aws_iam_role" "scheduler_invoke_role" {
  name               = "scheduler_lambda_invoke"
  assume_role_policy = data.aws_iam_policy_document.scheduler_assume_role.json
}

resource "aws_iam_role_policy" "scheduler_invoke_policy" {
  name   = "scheduler_lambda_invoke_policy"
  role   = aws_iam_role.scheduler_invoke_role.id
  policy = data.aws_iam_policy_document.scheduler_invoke_lambda.json
}


resource "aws_scheduler_schedule" "every_hour" {
  name        = "check-db-every-hour"
  group_name  = "ticket"
  schedule_expression = "rate(1 hour)" 
  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = aws_lambda_function.check_db.arn
    role_arn = aws_iam_role.scheduler_invoke_role.arn
    input    = jsonencode({}) 
  }
}