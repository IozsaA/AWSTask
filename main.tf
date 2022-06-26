terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random {
      source = "hashicorp/random"
    }
  }
}

provider "aws" {
  version    = "~> 2.0"
  region     = var.region
}

resource "aws_s3_bucket" "buck" {

  bucket = var.bucket_prefix
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"

  }
}

resource "aws_s3_bucket_object" "object" {

  bucket = aws_s3_bucket.buck.id

  key = "index.html"

  acl = "public-read"  # or can be "public-read"

  source = "project/index.html"

  etag = filemd5("project/index.html")

}

resource "aws_s3_bucket_policy" "buck" {
  bucket = aws_s3_bucket.buck.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.buck.id}/*"
            ]
        }
    ]
}
POLICY
}


locals {
  s3_origin_id = "buck"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.buck.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    #   s3_origin_config {
    #     origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
    #   }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "siuuuuu"
  default_root_object = "index.html"

  #   logging_config {
  #     include_cookies = true
  #     bucket          = "mylogs.s3.amazonaws.com"
  #     prefix          = "myprefix"
  #   }

  #aliases = []

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

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
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

  # Cache behavior with precedence 1
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

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

#resource "aws_cloudwatch_log_group" "example" {
#  name = "Example"
#}
#
#resource "aws_cloudtrail" "example" {
#  # ... other configuration ...
#  name = "cloudWatch"
#  s3_bucket_name = aws_s3_bucket.buck.id
#
#  cloud_watch_logs_group_arn =  "arn:aws:s3:::${aws_s3_bucket.buck.id}/*" # CloudTrail requires the Log Stream wildcard
#}