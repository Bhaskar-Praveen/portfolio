# ─── ROUTE 53 - Data source (zone already exists) ─────────────────────────────
data "aws_route53_zone" "portfolio" {
  name         = var.domain_name
  private_zone = false
}

# ─── A RECORD - Apex domain → CloudFront ──────────────────────────────────────
resource "aws_route53_record" "portfolio_apex" {
  zone_id = data.aws_route53_zone.portfolio.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.portfolio.domain_name
    zone_id                = aws_cloudfront_distribution.portfolio.hosted_zone_id
    evaluate_target_health = false
  }
}

# ─── AAAA RECORD - IPv6 apex domain → CloudFront ──────────────────────────────
resource "aws_route53_record" "portfolio_apex_ipv6" {
  zone_id = data.aws_route53_zone.portfolio.zone_id
  name    = var.domain_name
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.portfolio.domain_name
    zone_id                = aws_cloudfront_distribution.portfolio.hosted_zone_id
    evaluate_target_health = false
  }
}

# ─── A RECORD - WWW → CloudFront ──────────────────────────────────────────────
resource "aws_route53_record" "portfolio_www" {
  zone_id = data.aws_route53_zone.portfolio.zone_id
  name    = var.www_domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.portfolio.domain_name
    zone_id                = aws_cloudfront_distribution.portfolio.hosted_zone_id
    evaluate_target_health = false
  }
}

# ─── AAAA RECORD - IPv6 WWW → CloudFront ──────────────────────────────────────
resource "aws_route53_record" "portfolio_www_ipv6" {
  zone_id = data.aws_route53_zone.portfolio.zone_id
  name    = var.www_domain_name
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.portfolio.domain_name
    zone_id                = aws_cloudfront_distribution.portfolio.hosted_zone_id
    evaluate_target_health = false
  }
}
