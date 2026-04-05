terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "algadelivery_tfstate" {
  bucket = "algadelivery-tfstate"

  tags = {
    Name = "algadelivery-tfstate"
  }
}

# Fluxo básico:
# 1. tofu init   → inicializa o diretório, baixa providers
# 2. tofu plan   → mostra o que será criado/alterado/destruído
# 3. tofu apply  → aplica as mudanças na AWS
# 4. tofu destroy → destrói todos os recursos gerenciados
