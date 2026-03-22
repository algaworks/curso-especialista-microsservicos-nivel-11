terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Backend remoto com lock via DynamoDB
  # O OpenTofu adquire o lock automaticamente antes de apply/destroy
  # e libera ao finalizar, prevenindo execuções concorrentes.
  backend "s3" {
    bucket         = "algadelivery-tfstate-dev"
    key            = "global/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "algadelivery-tfstate-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}
