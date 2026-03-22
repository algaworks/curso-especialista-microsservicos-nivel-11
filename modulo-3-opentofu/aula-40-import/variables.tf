variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "project_name" {
  type    = string
  default = "algadelivery"
}
variable "environment" {
  type    = string
  default = "dev"
}

# IDs de recursos existentes na AWS para importar
variable "existing_vpc_id" {
  description = "ID da VPC existente para importar"
  type        = string
  default     = ""
}

variable "existing_bucket_name" {
  description = "Nome do bucket existente para importar"
  type        = string
  default     = ""
}
