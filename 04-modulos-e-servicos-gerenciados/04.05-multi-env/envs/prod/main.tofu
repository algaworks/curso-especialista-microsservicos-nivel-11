module "vpc" {
  source = "../../modules/vpc"

  aws_region                   = var.aws_region
  vpc_cidr_block               = var.vpc_cidr_block
  vpc_name                     = var.vpc_name
  context_name                 = local.context_name
  subnet_pub_config            = var.subnet_pub_config
  subnet_pvt_management_config = var.subnet_pvt_management_config
  subnet_pvt_cluster_config    = var.subnet_pvt_cluster_config
  ngw_regional_mode            = var.ngw_regional_mode
  common_tags                  = local.common_tags
}

module "ec2" {
  source = "../../modules/ec2"

  vpc_id                        = module.vpc.vpc_id
  vpc_cidr_block                = module.vpc.vpc_cidr_block
  public_subnet_ids             = module.vpc.public_subnet_ids
  private_management_subnet_ids = module.vpc.private_management_subnet_ids
  instance_type                 = var.instance_type
  keypair_name                  = var.keypair_name
  ami_id                        = data.aws_ami.ubuntu.id
  context_name                  = local.context_name
  common_tags                   = local.common_tags
  bastion_ingress_rules         = local.bastion_ingress_rules
  bastion_egress_rules          = local.bastion_egress_rules
  vm_private_ingress_rules      = local.vm_private_ingress_rules
  vm_private_egress_rules       = local.vm_private_egress_rules
}
