output "bucket_name" {
  description = "Nome do bucket S3 criado"
  value       = aws_s3_bucket.algadelivery_tfstate.bucket
}

output "bucket_arn" {
  description = "ARN do bucket S3"
  value       = aws_s3_bucket.algadelivery_tfstate.arn
}

output "bucket_region" {
  description = "Região onde o bucket está hospedado"
  value       = aws_s3_bucket.algadelivery_tfstate.region
}
