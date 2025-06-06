
# Used for MFA

resource "aws_sns_topic" "sns_res"{
    depends_on = [aws_cognito_user_pool.user_pool]
    name = "sns_mfa"

    policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "AllowCognitoToPublish",
        Effect = "Allow",
        Principal = {
          Service = "cognito-idp.amazonaws.com"
        },
        Action = "sns:Publish",
        Resource = aws_sns_topic.sns_res.arn,
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cognito_user_pool.user_pool.arn
          }
        }
      }
    ]
  })

}