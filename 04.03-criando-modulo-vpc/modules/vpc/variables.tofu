variable "aws_region" {
  type = string
}

variable "context_name" {
  type = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "subnet_pub_config" {
 description = "Configuration for public subnets"
  type = map(object({
    cidr_block = string
    az         = string
  }))
}

variable "subnet_pvt_management_config" {
  description = "Configuration for private management subnets"
  type = map(object({
    cidr_block = string
    az         = string
  }))
}

variable "subnet_pvt_cluster_config" {
 description = "Configuration for private cluster subnets"
  type = map(object({
    cidr_block = string
    az         = string
  }))
}

variable "ngw_regional_mode" {
  description = "The availability mode regional"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string) 
}