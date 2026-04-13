output "bucket_name" {
  description = "The name of the S3 bucket"
  value = aws_s3_bucket.algadelivery-teste-tofu.bucket
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value = aws_s3_bucket.algadelivery-teste-tofu.arn
}

output "bucket_url" {
  description = "The URL of the S3 bucket"
  value = aws_s3_bucket.algadelivery-teste-tofu.bucket_regional_domain_name
}