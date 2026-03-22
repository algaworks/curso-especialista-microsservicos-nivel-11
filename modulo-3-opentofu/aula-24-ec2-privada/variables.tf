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
variable "private_subnet_id" {
  type        = string
  description = "Subnet privada para a EC2 de management"
}
variable "key_name" {
  type = string
}
variable "allowed_ssh_cidr" {
  type    = string
  default = "0.0.0.0/0"
}
variable "bastion_instance_type" {
  type    = string
  default = "t3.micro"
}
variable "private_instance_type" {
  type    = string
  default = "t3.micro"
}
