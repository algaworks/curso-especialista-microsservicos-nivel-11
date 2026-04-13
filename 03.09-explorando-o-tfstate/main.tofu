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
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  } 
}

resource "aws_s3_bucket_versioning" "algadelivery-teste-tofu-versioning" {
  bucket = aws_s3_bucket.algadelivery-teste-tofu.id
  versioning_configuration {
    status = var.bucket_versioning
  }
}