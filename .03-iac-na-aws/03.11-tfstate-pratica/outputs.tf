output "bucket_name" {
  value = aws_s3_bucket.algadelivery_tfstate.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.algadelivery_tfstate.arn
}
