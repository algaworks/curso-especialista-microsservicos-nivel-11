output "bucket_name" {
  value = aws_s3_bucket.algadelivery_tfstate.bucket
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.algadelivery_tfstate_lock.name
}
