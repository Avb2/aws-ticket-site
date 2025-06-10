
# Used for MFA

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    sid    = "AllowCognitoToPublish"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cognito-idp.amazonaws.com"]
    }

    actions   = ["sns:Publish"]
    resources = ["*"] 

     condition {
       test     = "StringEquals"
       variable = "AWS:SourceArn"
       values   = ["arn:aws:cognito-idp:us-east-2:897729097986:userpool/us-east-2_LVlCSxu4M"]
     }
  }
}

# SNS topic used for Cognito MFA
resource "aws_sns_topic" "sns_res" {
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
        Resource = "*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cognito_user_pool.user_pool.arn
          },
          StringEqualsIfExists = {
            "sts:ExternalId" = local.external_id
          }
        }
      }
    ]
  })
}

