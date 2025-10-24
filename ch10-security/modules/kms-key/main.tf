terraform {
  required_providers {
    aws = {
      version = "~> 6.0"
      source  = "hashicorp/aws"
    }
  }
}

resource "aws_kms_key" "aws_exam_key" {
  description             = "sample aws encryption key"
  enable_key_rotation     = true
  deletion_window_in_days = 20
}

resource "aws_kms_alias" "a" {
  name          = "alias/my-key-alias"
  target_key_id = aws_kms_key.aws_exam_key.id
}

resource "aws_kms_key_policy" "aws_exam_key_policy" {
  key_id = aws_kms_key.aws_exam_key.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "${var.caller_arn}"
        },
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}