terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "algadelivery-tfstate"
    key    = "${var.environment}/networking/remote.tfstate"
    region = var.aws_region
  }
}

provider "aws" {
  region = var.aws_region
}