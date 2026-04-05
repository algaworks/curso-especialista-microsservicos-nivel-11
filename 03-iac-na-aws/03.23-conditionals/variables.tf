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
  type = string
}
variable "public_subnet_id" {
  type = string
}
variable "key_name" {
  type = string
}

variable "create_bastion" {
  description = "Se true, cria o Bastion Host"
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "Tipo de instância (t3.micro em dev, t3.small em prod)"
  type        = string
  default     = "t3.micro"
}
