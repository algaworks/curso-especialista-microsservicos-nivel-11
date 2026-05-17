module "msk" {
  source = "../../modules/msk"

  cluster_name             = "${var.environment}-${local.context_name}-msk"
  kafka_version            = var.msk_kafka_version
  number_of_broker_nodes   = var.msk_number_of_broker_nodes
  broker_instance_type     = var.msk_broker_instance_type
  broker_volume_size       = var.msk_broker_volume_size
  client_broker_encryption = var.msk_client_broker_encryption

  subnet_ids          = module.vpc.subnet_pvt_ids["cluster"]
  vpc_id              = module.vpc.vpc_id
  vpc_cidr            = module.vpc.vpc_cidr
  security_group_name = "${var.environment}-${local.context_name}-msk-sg"
  common_tags         = local.common_tags
}
