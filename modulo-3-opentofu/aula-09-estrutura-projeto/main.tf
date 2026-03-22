# Estrutura de projeto recomendada para OpenTofu/Terraform:
#
# main.tf       → Recursos principais
# variables.tf  → Declaração de variáveis de entrada
# outputs.tf    → Declaração de valores de saída
# locals.tf     → Valores locais calculados
# provider.tf   → Configuração do provider
# versions.tf   → Restrições de versão do terraform/tofu
# terraform.tfvars → Valores para as variáveis (não commitar secrets!)
#
# Para projetos com backend remoto, adiciona:
# backend.tf    → Configuração de backend (S3 + DynamoDB)

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
