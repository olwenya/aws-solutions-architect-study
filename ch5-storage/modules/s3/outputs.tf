output "website_url" {
  value = "http://${aws_s3_bucket_website_configuration.aws_exam_website_config.website_endpoint}"
}