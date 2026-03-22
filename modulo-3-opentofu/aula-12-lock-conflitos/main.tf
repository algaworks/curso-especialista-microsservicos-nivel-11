# ---------------------------------------------------------
# FASE 3 - Aula 12: Lock e conflitos
#
# Com o backend remoto configurado, o OpenTofu:
# 1. Adquire um lock na tabela DynamoDB antes de apply/destroy
# 2. Libera o lock ao concluir
# 3. Gera erro se outro processo já detiver o lock
#
# Para forçar liberação de um lock travado (use com cuidado!):
#   tofu force-unlock <LOCK_ID>
# ---------------------------------------------------------

resource "aws_s3_bucket" "algadelivery_tfstate" {
  bucket = local.bucket_name
  tags   = local.common_tags
}

resource "aws_s3_bucket_versioning" "algadelivery_tfstate" {
  bucket = aws_s3_bucket.algadelivery_tfstate.id

  versioning_configuration {

    status = "Enabled"

  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "algadelivery_tfstate" {
  bucket = aws_s3_bucket.algadelivery_tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "algadelivery_tfstate" {
  bucket = aws_s3_bucket.algadelivery_tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "algadelivery_tfstate_lock" {
  name         = local.lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {

    name = "LockID"

    type = "S"

  }
  tags = local.common_tags
}
