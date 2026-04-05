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

variable "public_subnet_cidrs" {
  description = "CIDRs das subnets públicas por AZ"
  type        = map(string)
  default = {
    a = "172.25.1.0/24"
    b = "172.25.2.0/24"
    c = "172.25.3.0/24"
  }
}

variable "management_subnet_cidrs" {
  description = "CIDRs das subnets de management por AZ"
  type        = map(string)
  default = {
    a = "172.25.4.0/24"
    b = "172.25.5.0/24"
    c = "172.25.6.0/24"
  }
}

variable "cluster_subnet_cidrs" {
  description = "CIDRs das subnets de cluster por AZ"
  type        = map(string)
  default = {
    a = "172.25.7.0/24"
    b = "172.25.8.0/24"
    c = "172.25.9.0/24"
  }
}

variable "allowed_ssh_cidr" {
  description = "CIDR permitido para SSH ao Bastion (restrinja ao seu IP!)"
  type        = string
  default     = "0.0.0.0/0"
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

variable "key_name" {
  description = "Nome do key pair SSH na AWS"
  type        = string
  default     = "algadelivery"
}
