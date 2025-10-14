terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

resource "aws_s3_bucket" "aws_exam_s3" {
  bucket = var.bucket_name
}

resource "aws_s3_object" "aws_exam_indexhtml" {
  bucket = aws_s3_bucket.aws_exam_s3.id
  source = var.index_page_path
  key    = "index.html"
  content_type = "text/html"
}

resource "aws_s3_bucket_website_configuration" "aws_exam_website_config" {
  bucket = aws_s3_bucket.aws_exam_s3.id

  index_document {
    suffix = "index.html"

  }
}

data "aws_iam_policy_document" "iam_policy" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"
    resources = [
      aws_s3_bucket.aws_exam_s3.arn,
      "${aws_s3_bucket.aws_exam_s3.arn}/*",
    ]
    actions = ["S3:GetObject"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
  depends_on = [aws_s3_bucket_public_access_block.public_access_block]
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.aws_exam_s3.id
  policy = data.aws_iam_policy_document.iam_policy.json
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.aws_exam_s3.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.aws_exam_s3.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.public_access_block]
}