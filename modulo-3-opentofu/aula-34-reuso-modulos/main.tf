# ---------------------------------------------------------
# Aula 34: Reuso de Módulos
#
# Aqui combinamos o módulo VPC e o módulo EC2.
# Os outputs do módulo VPC são passados como inputs
# para o módulo EC2, demonstrando composição de módulos.
# ---------------------------------------------------------
module "vpc" {
  source = "../aula-31-modulo-vpc/modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region
  vpc_cidr     = "172.31.0.0/16"
}

module "ec2" {
  source = "../aula-33-modulo-ec2/modules/ec2"

  project_name            = var.project_name
  environment             = var.environment
  vpc_id                  = module.vpc.vpc_id
  public_subnet_id        = module.vpc.public_subnet_ids["a"]
  private_subnet_id       = module.vpc.management_subnet_ids["a"]
  key_name                = var.key_name
  create_private_instance = true
}
