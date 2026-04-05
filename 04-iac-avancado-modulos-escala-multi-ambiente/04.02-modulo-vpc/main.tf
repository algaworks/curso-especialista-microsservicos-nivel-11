# ---------------------------------------------------------
# Aula 31: Módulo VPC
# Chama o módulo local de VPC, passando os inputs necessários.
# ---------------------------------------------------------
module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region
  vpc_cidr     = "172.31.0.0/16"
}
