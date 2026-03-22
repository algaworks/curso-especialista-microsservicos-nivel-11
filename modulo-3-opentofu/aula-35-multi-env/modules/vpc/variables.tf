variable "project_name" {
  type = string
}
variable "environment" {
  type = string
}
variable "vpc_cidr" {
  type    = string
  default = "172.31.0.0/16"
}
variable "aws_region" {
  type = string
}

variable "public_subnet_cidrs" {
  type = map(string)
  default = {
    a = "172.31.1.0/24"
    b = "172.31.2.0/24"
    c = "172.31.3.0/24"
  }
}

variable "management_subnet_cidrs" {
  type = map(string)
  default = {
    a = "172.31.4.0/24"
    b = "172.31.5.0/24"
    c = "172.31.6.0/24"
  }
}

variable "cluster_subnet_cidrs" {
  type = map(string)
  default = {
    a = "172.31.7.0/24"
    b = "172.31.8.0/24"
    c = "172.31.9.0/24"
  }
}
