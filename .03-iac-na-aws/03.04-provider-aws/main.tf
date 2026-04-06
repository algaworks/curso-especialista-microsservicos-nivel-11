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

  # Autenticação via variáveis de ambiente (recomendado):
  # export AWS_ACCESS_KEY_ID="..."
  # export AWS_SECRET_ACCESS_KEY="..."
  # export AWS_DEFAULT_REGION="us-east-1"
  #
  # Ou via AWS CLI profile:
  # profile = "default"
}