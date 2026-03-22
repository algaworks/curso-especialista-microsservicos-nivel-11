module "vpc" {
  source = "../../modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region
  vpc_cidr     = "172.31.0.0/16"
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
  bastion_instance_type   = "t3.micro"
  private_instance_type   = "t3.micro"
}
