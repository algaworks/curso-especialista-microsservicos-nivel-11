variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "aws_region" {
  description = "Região AWS"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block da VPC"
  type        = string
  default     = "172.31.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDRs das subnets públicas por sufixo de AZ"
  type        = map(string)
  default = {
    a = "172.31.1.0/24"
    b = "172.31.2.0/24"
    c = "172.31.3.0/24"
  }
}

variable "management_subnet_cidrs" {
  description = "CIDRs das subnets de management (privadas)"
  type        = map(string)
  default = {
    a = "172.31.4.0/24"
    b = "172.31.5.0/24"
    c = "172.31.6.0/24"
  }
}

variable "cluster_subnet_cidrs" {
  description = "CIDRs das subnets de cluster (privadas)"
  type        = map(string)
  default = {
    a = "172.31.7.0/24"
    b = "172.31.8.0/24"
    c = "172.31.9.0/24"
  }
}
