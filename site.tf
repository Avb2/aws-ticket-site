resource "aws_s3_bucket" "site_bucket" {
    bucket = "ticket-site-060625"

}

resource "aws_s3_bucket_policy" "cf_log_bucket_policy" {
  bucket = aws_s3_bucket.site_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AWSCloudFrontLogs",
        Effect    = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action    = "s3:PutObject",
        Resource  = "${aws_s3_bucket.site_bucket.arn}/*"
      }
    ]
  })
}




resource "aws_s3_bucket_website_configuration" "site_config" {
    bucket = aws_s3_bucket.site_bucket.id

      index_document {
        suffix = "index.html"
    }

    error_document {
        key = "index.html"
    }
}



data "aws_iam_policy_document" "site_bucket_policy_doc" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = ["s3:GetObject"]

    resources = [
      "${aws_s3_bucket.site_bucket.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "site_bucket_policy" {
  bucket = aws_s3_bucket.site_bucket.id
  policy = data.aws_iam_policy_document.site_bucket_policy_doc.json
}
