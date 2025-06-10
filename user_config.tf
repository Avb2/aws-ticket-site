resource "aws_iam_policy" "cf_s3_acl_access" {
  name = "cf-s3-acl-access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement: [
      {
        Effect = "Allow",
        Action: [
          "s3:GetBucketAcl",
          "s3:PutBucketAcl"
        ],
        Resource = "arn:aws:s3:::cf-log-bucket-060625"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "attach_cf_acl" {
  user       = "alexanderbringuel"
  policy_arn = aws_iam_policy.cf_s3_acl_access.arn
}
