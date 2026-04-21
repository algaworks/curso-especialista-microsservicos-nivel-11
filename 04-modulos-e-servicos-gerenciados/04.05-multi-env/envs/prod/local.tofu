locals {
  context_name        = "algadelivery"
  ngw_regional_mode   = var.ngw_regional_mode ? "regional" : "zonal"
  internet_cidr_block = "0.0.0.0/0"
  my_public_ip        = "${trimspace(data.http.my_public_ip.response_body)}/32"

  common_tags = {
    Environment = var.environment
    ManagedBy   = "OpenTofu"
  }

  bastion_ingress_rules = length(var.bastion_ingress_rules) > 0 ? var.bastion_ingress_rules : [
    {
      description = "SSH da internet"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [local.my_public_ip]
    }
  ]

  bastion_egress_rules = length(var.bastion_egress_rules) > 0 ? var.bastion_egress_rules : [
    {
      description = "Todo o trafego de saida"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [local.internet_cidr_block]
    }
  ]

  vm_private_ingress_rules = length(var.vm_private_ingress_rules) > 0 ? var.vm_private_ingress_rules : [
    {
      description = "SSH para VPC"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.vpc_cidr_block]
    }
  ]

  vm_private_egress_rules = length(var.vm_private_egress_rules) > 0 ? var.vm_private_egress_rules : [
    {
      description = "Todo o trafego de saida"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [local.internet_cidr_block]
    }
  ]
}
