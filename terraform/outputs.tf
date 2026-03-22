# ─── OUTPUTS ──────────────────────────────────────────────────────────────────
output "website_url" {
  description = "Live portfolio URL"
  value       = "https://${var.domain_name}"
}

output "cloudfront_distribution_id" {
  description = "CloudFront Distribution ID - needed for cache invalidation"
  value       = aws_cloudfront_distribution.portfolio.id
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name"
  value       = aws_cloudfront_distribution.portfolio.domain_name
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.portfolio.id
}

output "s3_website_endpoint" {
  description = "S3 static website endpoint"
  value       = aws_s3_bucket_website_configuration.portfolio.website_endpoint
}

output "acm_certificate_arn" {
  description = "ACM Certificate ARN"
  value       = aws_acm_certificate.portfolio.arn
}

output "route53_zone_id" {
  description = "Route 53 Hosted Zone ID"
  value       = data.aws_route53_zone.portfolio.zone_id
}
