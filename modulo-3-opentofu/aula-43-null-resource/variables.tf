variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "project_name" {
  type    = string
  default = "algadelivery"
}
variable "bastion_ip" {
  type        = string
  description = "IP público do Bastion"
}
variable "key_path" {
  type        = string
  description = "Caminho local para a chave PEM"
}
