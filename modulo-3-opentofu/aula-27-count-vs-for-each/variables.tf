variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "project_name" {
  type    = string
  default = "algadelivery"
}
variable "vpc_id" {
  type = string
}
variable "subnet_count" {
  type    = number
  default = 3
}

variable "subnet_cidrs" {
  type    = list(string)
  default = ["172.31.1.0/24", "172.31.2.0/24", "172.31.3.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "subnets_map" {
  description = "Mapa para criação com for_each"
  type        = map(string)
  default = {
    "us-east-1a" = "172.31.1.0/24"
    "us-east-1b" = "172.31.2.0/24"
    "us-east-1c" = "172.31.3.0/24"
  }
}
