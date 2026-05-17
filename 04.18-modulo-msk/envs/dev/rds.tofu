ephemeral "random_password" "db" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "rds" {
  source = "../../modules/rds"

  db_identifier           = "${var.environment}-${local.context_name}-rds"
  db_name                 = var.db_name
  db_username             = var.db_username
  db_password             = ephemeral.random_password.db.result
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  multi_az                = var.db_multi_az
  skip_final_snapshot     = var.db_skip_final_snapshot
  subnet_ids              = module.vpc.subnet_pvt_ids["database"]
  vpc_id                  = module.vpc.vpc_id
  vpc_cidr                = module.vpc.vpc_cidr
  common_tags             = local.common_tags
  db_subnet_group_name    = "${var.environment}-${local.context_name}-rds-subnet-group"
  db_parameter_group_name = "${var.environment}-${local.context_name}-rds-pg"
  security_group_name     = "${var.environment}-${local.context_name}-rds-sg"
  db_parameter_group      = var.db_parameter_group
}
