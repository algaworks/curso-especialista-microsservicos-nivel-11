# ---------------------------------------------------------
# Aula 33: Módulo EC2
# ---------------------------------------------------------
module "ec2" {
  source = "./modules/ec2"

  project_name            = var.project_name
  environment             = var.environment
  vpc_id                  = var.vpc_id
  public_subnet_id        = var.public_subnet_id
  private_subnet_id       = var.private_subnet_id
  key_name                = var.key_name
  create_private_instance = true
}
