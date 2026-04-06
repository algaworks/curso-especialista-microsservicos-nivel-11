module "vpc" {
  source = "../../modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region
  vpc_cidr     = "10.0.0.0/16"

  public_subnet_cidrs = {
    a = "10.0.1.0/24"
    b = "10.0.2.0/24"
    c = "10.0.3.0/24"
  }
  management_subnet_cidrs = {
    a = "10.0.4.0/24"
    b = "10.0.5.0/24"
    c = "10.0.6.0/24"
  }
  cluster_subnet_cidrs = {
    a = "10.0.7.0/24"
    b = "10.0.8.0/24"
    c = "10.0.9.0/24"
  }
}

module "ec2" {
  source = "../../modules/ec2"

  project_name            = var.project_name
  environment             = var.environment
  vpc_id                  = module.vpc.vpc_id
  public_subnet_id        = module.vpc.public_subnet_ids["a"]
  private_subnet_id       = module.vpc.management_subnet_ids["a"]
  key_name                = var.key_name
  create_private_instance = true
  bastion_instance_type   = "t3.small"
  private_instance_type   = "t3.medium"
}
