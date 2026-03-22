output "bucket_name" {
  description = "Nome do bucket de estado"
  value       = aws_s3_bucket.algadelivery_tfstate.bucket
}

output "bucket_arn" {
  description = "ARN do bucket de estado"
  value       = aws_s3_bucket.algadelivery_tfstate.arn
}

output "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB de lock"
  value       = aws_dynamodb_table.algadelivery_tfstate_lock.name
}
