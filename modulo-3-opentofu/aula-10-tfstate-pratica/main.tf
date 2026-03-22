# ---------------------------------------------------------
# FASE 3 - Aula 10: tfstate na prática
#
# O arquivo terraform.tfstate armazena o estado atual da
# infraestrutura gerenciada pelo OpenTofu/Terraform.
#
# Comandos úteis:
#   tofu show                 → mostra o estado atual
#   tofu state list           → lista todos os recursos
#   tofu state show <recurso> → detalha um recurso
#   tofu refresh              → atualiza o estado com a nuvem
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
