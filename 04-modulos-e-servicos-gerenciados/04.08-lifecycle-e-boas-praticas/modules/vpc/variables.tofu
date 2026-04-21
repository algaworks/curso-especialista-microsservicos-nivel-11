variable "aws_region" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "context_name" {
  type = string
}

variable "subnet_pub_config" {
  type = map(object({
    cidr_block = string
    az         = string
  }))
}

variable "subnet_pvt_management_config" {
  type = map(object({
    cidr_block = string
    az         = string
  }))
}

variable "subnet_pvt_cluster_config" {
  type = map(object({
    cidr_block = string
    az         = string
  }))
}

variable "ngw_regional_mode" {
  type    = bool
  default = true
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
