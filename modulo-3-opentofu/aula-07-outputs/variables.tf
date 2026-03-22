variable "aws_region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "algadelivery"
}

variable "bucket_name" {
  description = "Nome do bucket S3 para armazenar o tfstate"
  type        = string
  default     = "algadelivery-tfstate"
}
