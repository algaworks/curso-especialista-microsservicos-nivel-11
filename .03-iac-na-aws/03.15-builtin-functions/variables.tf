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

variable "vpc_cidr" {
  type    = string
  default = "172.31.0.0/16"
}

variable "subnet_configs" {
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
  default = [
    {
      name              = "pub-a"
      cidr_block        = "172.31.1.0/24"
      availability_zone = "a"
    },
    {
      name              = "pub-b"
      cidr_block        = "172.31.2.0/24"
      availability_zone = "b"
    },
    {
      name              = "pub-c"
      cidr_block        = "172.31.3.0/24"
      availability_zone = "c"
    }
  ]
}
