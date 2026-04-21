variable "aws_region" {
  default = "us-east-1"
}

variable "environment" {
  description = "The environment for the S3 bucket (development, homolog, production)"
  type        = string
  default     = "production"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "172.26.0.0/16"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "algadelivery-vpc"
}

variable "subnet_pub_config" {
  type = map(object({
    cidr_block = string
    az         = string
  }))
  default = {
    "public_a" = {
      cidr_block = "172.26.1.0/24"
      az         = "a"
    },
    "public_b" = {
      cidr_block = "172.26.2.0/24"
      az         = "b"
    },
    "public_c" = {
      cidr_block = "172.26.3.0/24"
      az         = "c"
    }
  }
}

variable "subnet_pvt_management_config" {
  type = map(object({
    cidr_block = string
    az         = string
  }))
  default = {
    "private_a" = {
      cidr_block = "172.26.4.0/24"
      az         = "a"
    },
    "private_b" = {
      cidr_block = "172.26.5.0/24"
      az         = "b"
    },
    "private_c" = {
      cidr_block = "172.26.6.0/24"
      az         = "c"
    }
  }
}

variable "subnet_pvt_cluster_config" {
  type = map(object({
    cidr_block = string
    az         = string
  }))
  default = {
    "private_a" = {
      cidr_block = "172.26.7.0/24"
      az         = "a"
    },
    "private_b" = {
      cidr_block = "172.26.8.0/24"
      az         = "b"
    },
    "private_c" = {
      cidr_block = "172.26.9.0/24"
      az         = "c"
    }
  }
}

variable "ngw_regional_mode" {
  description = "The availability mode regional"
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "The type of instance to use"
  type        = string
  default     = "t3.small"
}

variable "keypair_name" {
  type    = string
  default = "algadelivery-iac"
}

variable "ami_id" {
  description = "The ID of the AMI to use for the instance"
  type        = string
  default     = "ami-04680790a315cd58d"
}

variable "bastion_ingress_rules" {
  description = "Ingress rules for bastion security group"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "bastion_egress_rules" {
  description = "Egress rules for bastion security group"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "vm_private_ingress_rules" {
  description = "Ingress rules for private VM security group"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "vm_private_egress_rules" {
  description = "Egress rules for private VM security group"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []}
