resource "aws_cloudfront_distribution" "s3_distribution" {
  provider = aws.aws-us
  enabled             = true
  default_root_object = "index.html"
  price_class = "PriceClass_100"

  origin {
    domain_name = aws_s3_bucket.frontend_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.frontend_bucket.bucket
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }
  # aliases = var.dns

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.frontend_bucket.bucket
    
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }
  
  viewer_certificate {
    cloudfront_default_certificate = true
    #acm_certificate_arn = var.certificate_arn
    minimum_protocol_version = "TLSv1.2_2019"
    ssl_support_method = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  #web_acl_id = aws_wafv2_web_acl.waf.arn

  tags = var.tags

  depends_on = [
    aws_cloudfront_origin_access_identity.oai
  ]
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  provider = aws.aws-us

  comment = "OAI for ${var.name}"
}

####
####
####################
####

resource "aws_s3_bucket" "frontend_bucket" {
  bucket                    = "bcket-${var.name}-frontend"
  tags                      = var.tags
}

resource "aws_s3_bucket_policy" "frontend_bucket_policy_association" {
  bucket  = aws_s3_bucket.frontend_bucket.id
  policy  = data.aws_iam_policy_document.frontend_bucket_policy.json
}

data "aws_iam_policy_document" "frontend_bucket_policy" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      aws_s3_bucket.frontend_bucket.arn,
      "${aws_s3_bucket.frontend_bucket.arn}/*",
    ]
    principals {
      type    = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    }
  }
}

resource "aws_s3_bucket_public_access_block" "frontend_bucket_access_bloc" {
  bucket                  = aws_s3_bucket.frontend_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "frontend_bucket_ownership" {
  bucket = aws_s3_bucket.frontend_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
