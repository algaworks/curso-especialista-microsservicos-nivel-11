variable "aws_region" {
  default = "us-east-1"
}

variable "bucket_name" {
    description = "The name of the S3 bucket"
    type = string
    default = "algadelivery-teste-tofu"
}

variable "environment" {
    description = "The environment for the S3 bucket (development, homolog, production)"
    type = string
    default = "development"
}

variable "bucket_versioning" {
   description = "The versioning status for the S3 bucket (Enabled or Suspended or Disabled)" 
   type = string
   default = "Enabled"
}