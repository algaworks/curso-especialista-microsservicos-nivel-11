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
  type = string
}
variable "key_name" {
  type = string
}
