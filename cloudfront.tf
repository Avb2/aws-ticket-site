locals {
    s3_origin_id = "s3origin"
}

resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "S3-OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


resource "aws_cloudfront_distribution" "s3_distribution" {
    origin {
        domain_name = aws_s3_bucket.site_bucket.bucket_regional_domain_name
        origin_access_control_id = aws_cloudfront_origin_access_control.default.id
        origin_id = local.s3_origin_id
    }
    

    enabled = true
    is_ipv6_enabled = true

    default_root_object = "index.html"

    logging_config {
        include_cookies = false
        bucket = aws_s3_bucket.log_bucket.bucket_domain_name
        prefix = "logs/"
    }


    default_cache_behavior {
        allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = local.s3_origin_id

        
       
        forwarded_values {
            query_string = false

            cookies {
                forward = "none"
            }
        }
        

        viewer_protocol_policy = "redirect-to-https"
        min_ttl     = 0
        default_ttl = 3600     
        max_ttl     = 86400 

    }


    ordered_cache_behavior {
        path_pattern     = "/content/immutable/*"
        allowed_methods  = ["GET", "HEAD", "OPTIONS"]
        cached_methods   = ["GET", "HEAD", "OPTIONS"]
        target_origin_id = local.s3_origin_id

        forwarded_values {
        query_string = false
        headers      = ["Origin"]

        cookies {
            forward = "none"
        }
        }

        min_ttl                = 0
        default_ttl            = 86400
        max_ttl                = 31536000
        compress               = true
        viewer_protocol_policy = "redirect-to-https"
    }

    ordered_cache_behavior {
        path_pattern     = "/content/*"
        allowed_methods  = ["GET", "HEAD", "OPTIONS"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = local.s3_origin_id

        forwarded_values {
        query_string = false

        cookies {
            forward = "none"
        }
        }

        min_ttl                = 0
        default_ttl            = 3600
        max_ttl                = 86400
        compress               = true
        viewer_protocol_policy = "redirect-to-https"
    }


    price_class = "PriceClass_100"

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    viewer_certificate {
    cloudfront_default_certificate = true
  }


}

resource "aws_s3_bucket_ownership_controls" "log_bucket_acl_control" {
  bucket = aws_s3_bucket.log_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.log_bucket_acl_control]
  bucket     = aws_s3_bucket.log_bucket.id
  acl        = "log-delivery-write"
}



data "aws_iam_policy_document" "cf_read_access" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.site_bucket.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "allow_cf_access" {
  bucket = aws_s3_bucket.site_bucket.id
  policy = data.aws_iam_policy_document.cf_read_access.json
}
