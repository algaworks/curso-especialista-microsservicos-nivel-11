terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
}

resource "aws_s3_bucket" "algadelivery-teste-tofu" {
  bucket = "algadelivery-teste-tofu"

  tags = {
    Name        = "algadelivery-teste-tofu"
    Environment = "Development"
  }
  
}