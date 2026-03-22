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
  description = "ID da VPC (output do layer de network)"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR permitido para acesso SSH ao Bastion"
  type        = string
  default     = "0.0.0.0/0" # Restrinja ao seu IP em produção!
}
