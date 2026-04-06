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

variable "subnets" {
  description = "Mapa de subnets a criar: az → cidr"
  type        = map(string)
  default = {
    "us-east-1a" = "172.31.1.0/24"
    "us-east-1b" = "172.31.2.0/24"
    "us-east-1c" = "172.31.3.0/24"
  }
}
