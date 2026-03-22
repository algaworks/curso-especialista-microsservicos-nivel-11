variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "algadelivery"
}

variable "environment" {
  description = "Ambiente (dev, prod)"
  type        = string
  default     = "dev"
}

variable "key_name" {
  description = "Nome do key pair SSH na AWS"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR permitido para SSH no Bastion (seu IP)"
  type        = string
  default     = "0.0.0.0/0"
}
