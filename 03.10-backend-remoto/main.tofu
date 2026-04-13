terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "algadelivery-tfstate"
    key    = "${var.environment}/s3/${var.bucket_name}/remote.tfstate"
    region = var.aws_region
  }
}

provider "aws" {
  region     = var.aws_region
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