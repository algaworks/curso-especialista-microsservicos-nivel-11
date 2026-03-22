# ==========================================================
# PROJETO FINAL — AlgaDelivery Infrastructure
#
# Arquitetura:
#  VPC 172.31.0.0/16 (us-east-1)
#  ├── Subnets Públicas   (a/b/c)  → Internet Gateway
#  ├── Subnets Management (a/b/c)  → NAT Gateway
#  └── Subnets Cluster    (a/b/c)  → NAT Gateway
#
#  EC2 Bastion  → Subnet Pública    → Acesso SSH da internet
#  EC2 Private  → Subnet Management → Acesso SSH via Bastion
# ==========================================================

module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region
  vpc_cidr     = "172.31.0.0/16"

  public_subnet_cidrs = {
    a = "172.31.1.0/24"
    b = "172.31.2.0/24"
    c = "172.31.3.0/24"
  }

  management_subnet_cidrs = {
    a = "172.31.4.0/24"
    b = "172.31.5.0/24"
    c = "172.31.6.0/24"
  }

  cluster_subnet_cidrs = {
    a = "172.31.7.0/24"
    b = "172.31.8.0/24"
    c = "172.31.9.0/24"
  }
}

module "ec2" {
  source = "./modules/ec2"

  project_name            = var.project_name
  environment             = var.environment
  vpc_id                  = module.vpc.vpc_id
  public_subnet_id        = module.vpc.public_subnet_ids["a"]
  private_subnet_id       = module.vpc.management_subnet_ids["a"]
  key_name                = var.key_name
  allowed_ssh_cidr        = var.allowed_ssh_cidr
  bastion_instance_type   = local.bastion_instance_type
  private_instance_type   = local.private_instance_type
  create_private_instance = true
}
