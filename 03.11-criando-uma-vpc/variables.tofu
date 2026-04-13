variable "aws_region" {
  default = "us-east-1"
}

variable "environment" {
    description = "The environment for the S3 bucket (development, homolog, production)"
    type = string
    default = "development"
}

variable "vpc_cidr_block" {
    description = "The CIDR block for the VPC"
    type = string
    default = "172.25.0.0/16"
}

variable "vpc_name" {
    description = "The name of the VPC"
    type = string
    default = "algadelivery-vpc"
}