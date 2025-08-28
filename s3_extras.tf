# --- S3 extras: versioning & SSE for existing assets bucket, plus ALB logs bucket ---

resource "aws_s3_bucket_versioning" "assets" {
  bucket = aws_s3_bucket.assets.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "assets" {
  bucket = aws_s3_bucket.assets.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Bucket for ALB access logs: s3logs-project-operation-num-region
resource "aws_s3_bucket" "alb_logs" {
  bucket        = "s3logs-${local.name_prefix}"
  force_destroy = true
}

resource "aws_s3_bucket_lifecycle_configuration" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id
  rule {
    id     = "expire-90-days"
    status = "Enabled"
    filter {
      prefix = ""
    }
    expiration {
      days = 90
    }
  }
}

data "aws_elb_service_account" "this" {}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "alb_logs" {
  bucket = aws_s3_bucket.alb_logs.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "ELBLogDeliveryWrite",
        Effect    = "Allow",
        Principal = { AWS = data.aws_elb_service_account.this.arn },
        Action    = ["s3:PutObject"],
        Resource  = "${aws_s3_bucket.alb_logs.arn}/*"
      },
      {
        Sid       = "ELBLogDeliveryGetBucketAcl",
        Effect    = "Allow",
        Principal = { AWS = data.aws_elb_service_account.this.arn },
        Action    = ["s3:GetBucketAcl"],
        Resource  = aws_s3_bucket.alb_logs.arn
      }
    ]
  })
}
