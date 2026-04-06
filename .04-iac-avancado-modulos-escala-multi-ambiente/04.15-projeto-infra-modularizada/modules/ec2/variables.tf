variable "project_name" {
  type = string
}
variable "environment" {
  type = string
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
variable "create_private_instance" {
  type    = bool
  default = true
}
