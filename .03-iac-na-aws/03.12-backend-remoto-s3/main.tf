# ---------------------------------------------------------
# FASE 3 - Aula 11: Backend remoto com S3
#
# PASSO 1: Crie o bucket e a tabela DynamoDB manualmente
#          (ou via aula-10) antes de configurar o backend.
#
# PASSO 2: Execute: tofu init
#          O OpenTofu migrará o estado local para o S3.
# ---------------------------------------------------------

# Cria o bucket de estado (execute ANTES de configurar o backend)
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

# Tabela DynamoDB para lock do state
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
