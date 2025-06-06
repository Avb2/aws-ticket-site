resource "aws_s3_bucket" "log_bucket" {
    bucket = "cf-log-bucket-060625"
}


resource "aws_s3_bucket_policy" "cf_log_policy" {
    bucket = aws_s3_bucket.log_bucket.id
    policy = data.aws_iam_policy_document.s3_log_policy.json
}


data "aws_iam_policy_document" "s3_log_policy" {
    statement {
        principals {
            type        = "Service"
            identifiers = ["cloudfront.amazonaws.com"]
        }
        actions = [
            "s3:PutObject"
        ]

        resources = [
            "${aws_s3_bucket.log_bucket.arn}/*"
        ]
    }
}