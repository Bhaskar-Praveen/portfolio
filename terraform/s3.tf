# ─── S3 BUCKET - Primary (apex domain) ───────────────────────────────────────
resource "aws_s3_bucket" "portfolio" {
  bucket = var.domain_name

  tags = {
    Name        = var.domain_name
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "terraform"
  }
}

# Block public access - CloudFront will be the only entry point
resource "aws_s3_bucket_public_access_block" "portfolio" {
  bucket = aws_s3_bucket.portfolio.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "portfolio" {
  bucket = aws_s3_bucket.portfolio.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# Bucket policy - allow public read
resource "aws_s3_bucket_policy" "portfolio" {
  bucket = aws_s3_bucket.portfolio.id

  depends_on = [aws_s3_bucket_public_access_block.portfolio]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.portfolio.arn}/*"
      }
    ]
  })
}

# ─── S3 BUCKET - WWW redirect ─────────────────────────────────────────────────
resource "aws_s3_bucket" "www_portfolio" {
  bucket = var.www_domain_name

  tags = {
    Name        = var.www_domain_name
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "terraform"
  }
}

# WWW bucket redirects to apex domain
resource "aws_s3_bucket_website_configuration" "www_portfolio" {
  bucket = aws_s3_bucket.www_portfolio.id

  redirect_all_requests_to {
    host_name = var.domain_name
    protocol  = "https"
  }
}
