# ---------------------------------------------------------
# Aula 40: Import
#
# MÉTODO 1: Linha de comando (OpenTofu/Terraform < 1.5)
#
#   tofu import aws_vpc.existing vpc-0abc123def456
#   tofu import aws_s3_bucket.existing meu-bucket-existente
#
# MÉTODO 2: Bloco import (OpenTofu >= 1.6 / Terraform >= 1.5)
# Declarativo — mais claro e rastreável no código.
# ---------------------------------------------------------

# Importar uma VPC existente
import {
  to = aws_vpc.existing
  id = var.existing_vpc_id
}
resource "aws_vpc" "existing" {
  # Preencha com os valores reais da VPC que será importada
  cidr_block           = "172.31.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project_name}-vpc"
    Project     = var.project_name
    Environment = var.environment
  }
}

# Importar um bucket S3 existente
import {
  to = aws_s3_bucket.existing
  id = var.existing_bucket_name
}
resource "aws_s3_bucket" "existing" {
  bucket = var.existing_bucket_name

  tags = {
    Name    = var.existing_bucket_name
    Project = var.project_name
  }
}

# ---------------------------------------------------------
# Dica: Use `tofu plan -generate-config-out=generated.tf`
# para gerar automaticamente a configuração de um recurso
# antes de importar (OpenTofu >= 1.6)
# ---------------------------------------------------------
