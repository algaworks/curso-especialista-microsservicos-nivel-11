variable "vpc_id" { type = string }
variable "vpc_cidr_block" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "private_management_subnet_ids" { type = list(string) }
variable "instance_type" { type = string, default = "t3.micro" }
variable "keypair_name" { type = string }
variable "ami_id" { type = string }
variable "context_name" { type = string }
variable "common_tags" { type = map(string), default = {} }
variable "bastion_ingress_rules" { type = list(object({ description = string, from_port = number, to_port = number, protocol = string, cidr_blocks = list(string) })) }
variable "bastion_egress_rules" { type = list(object({ description = string, from_port = number, to_port = number, protocol = string, cidr_blocks = list(string) })) }
variable "vm_private_ingress_rules" { type = list(object({ description = string, from_port = number, to_port = number, protocol = string, cidr_blocks = list(string) })) }
variable "vm_private_egress_rules" { type = list(object({ description = string, from_port = number, to_port = number, protocol = string, cidr_blocks = list(string) })) }
