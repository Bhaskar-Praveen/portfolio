# ─── CLOUDFRONT DISTRIBUTION ──────────────────────────────────────────────────
resource "aws_cloudfront_distribution" "portfolio" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = [var.domain_name, var.www_domain_name]
  price_class         = "PriceClass_All"
  comment             = "Portfolio - ${var.domain_name}"

  # ─── ORIGIN - S3 Website Endpoint ─────────────────────────────────────────
  origin {
    domain_name = aws_s3_bucket_website_configuration.portfolio.website_endpoint
    origin_id   = "S3-${var.domain_name}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # ─── DEFAULT CACHE BEHAVIOR ───────────────────────────────────────────────
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${var.domain_name}"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    # Cache for 1 day in production
    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000
  }

  # ─── SSL CERTIFICATE ──────────────────────────────────────────────────────
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.portfolio.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # ─── GEO RESTRICTION ──────────────────────────────────────────────────────
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # ─── CUSTOM ERROR PAGES (SPA support) ─────────────────────────────────────
  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 300
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 300
  }

  tags = {
    Name        = var.domain_name
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "terraform"
  }

  depends_on = [aws_acm_certificate_validation.portfolio]
}
