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
  default     = "172.31.0.0/16"
}
variable "public_subnet_cidrs" {
  description = "CIDRs das subnets públicas por AZ"
  type        = map(string)
  default = {
    a = "172.31.1.0/24"
    b = "172.31.2.0/24"
    c = "172.31.3.0/24"
  }
}
variable "management_subnet_cidrs" {
  description = "CIDRs das subnets de management por AZ"
  type        = map(string)
  default = {
    a = "172.31.4.0/24"
    b = "172.31.5.0/24"
    c = "172.31.6.0/24"
  }
}
variable "cluster_subnet_cidrs" {
  description = "CIDRs das subnets de cluster por AZ"
  type        = map(string)
  default = {
    a = "172.31.7.0/24"
    b = "172.31.8.0/24"
    c = "172.31.9.0/24"
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
