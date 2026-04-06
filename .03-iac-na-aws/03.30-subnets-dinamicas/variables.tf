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
  description = "Ambiente (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block da VPC"
  type        = string
  default     = "172.25.0.0/16"
}

variable "bastion_instance_type" {
  description = "Tipo de instância do Bastion"
  type        = string
  default     = "t3.micro"
}

variable "private_instance_type" {
  description = "Tipo de instância privada"
  type        = string
  default     = "t3.micro"
}
