data "http" "my_public_ip" { url = "https://checkip.amazonaws.com/" }
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter { name = "name", values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"] }
  filter { name = "architecture", values = ["x86_64"] }
  filter { name = "virtualization-type", values = ["hvm"] }
}

module "vpc" {
  source = "../../modules/vpc"
  aws_region = var.aws_region
  vpc_cidr_block = local.config.vpc_cidr_block
  vpc_name = local.config.vpc_name
  context_name = local.context_name
  subnet_pub_config = local.config.subnet_pub_config
  subnet_pvt_management_config = local.config.subnet_pvt_management_config
  subnet_pvt_cluster_config = local.config.subnet_pvt_cluster_config
  common_tags = local.common_tags
}

module "ec2" {
  source = "../../modules/ec2"
  vpc_id = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block
  public_subnet_ids = module.vpc.public_subnet_ids
  private_management_subnet_ids = module.vpc.private_management_subnet_ids
  instance_type = local.config.instance_type
  keypair_name = var.keypair_name
  ami_id = data.aws_ami.ubuntu.id
  context_name = local.context_name
  common_tags = local.common_tags
  bastion_ingress_rules = [{ description = "SSH da internet", from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = [local.my_public_ip] }]
  bastion_egress_rules = [{ description = "Todo o trafego de saida", from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = [local.internet_cidr_block] }]
  vm_private_ingress_rules = [{ description = "SSH para VPC", from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = [local.config.vpc_cidr_block] }]
  vm_private_egress_rules = [{ description = "Todo o trafego de saida", from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = [local.internet_cidr_block] }]
}

module "rds" {
  source         = "../../modules/rds"
  context_name   = local.context_name
  vpc_id         = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block
  subnet_ids     = module.vpc.private_cluster_subnet_ids
  db_password    = var.db_password
  common_tags    = local.common_tags
}
