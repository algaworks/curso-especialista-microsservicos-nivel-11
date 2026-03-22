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

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "public_subnet_id" {
  description = "ID de uma subnet pública para o Bastion"
  type        = string
}

variable "bastion_instance_type" {
  description = "Tipo de instância do Bastion"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Nome do key pair SSH na AWS"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR permitido para SSH ao Bastion (restrinja ao seu IP!)"
  type        = string
  default     = "0.0.0.0/0"
}
