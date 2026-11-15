# Exemplo de valores do ambiente. Copie e ajuste antes de usar:
#   cp example.tfvars dev.tfvars     (ou prod.tfvars)
# dev.tfvars e prod.tfvars ficam fora do Git (.gitignore).
#
# Valores do ambiente de desenvolvimento. Uso:
#   tofu init -reconfigure -var-file=dev.tfvars
#   tofu plan -var-file=dev.tfvars
#
# Sem segredos: pode ir para o Git. Segredo vai em TF_VAR_*, nunca aqui.

environment = "development"

vpc_cidr_block = "172.25.0.0/16"

subnet_pub_config = {
  public = {
    "pub_a" = { cidr_block = "172.25.1.0/24", az = "a" },
    "pub_b" = { cidr_block = "172.25.2.0/24", az = "b" },
    "pub_c" = { cidr_block = "172.25.3.0/24", az = "c" }
  }
}

subnet_pvt_config = {
  management = {
    "pvt_mgmt_a" = { cidr_block = "172.25.4.0/24", az = "a" },
    "pvt_mgmt_b" = { cidr_block = "172.25.5.0/24", az = "b" },
    "pvt_mgmt_c" = { cidr_block = "172.25.6.0/24", az = "c" }
  },
  cluster = {
    "pvt_cluster_a" = { cidr_block = "172.25.7.0/24", az = "a" },
    "pvt_cluster_b" = { cidr_block = "172.25.8.0/24", az = "b" },
    "pvt_cluster_c" = { cidr_block = "172.25.9.0/24", az = "c" }
  },
  database = {
    "pvt_db_a" = { cidr_block = "172.25.10.0/24", az = "a" },
    "pvt_db_b" = { cidr_block = "172.25.11.0/24", az = "b" },
    "pvt_db_c" = { cidr_block = "172.25.12.0/24", az = "c" }
  }
}

db_parameter_group_options = {
  max_connections          = "300"
  shared_preload_libraries = "pg_stat_statements,pgaudit"
}

db_instance_class = "db.t4g.micro"

db_storage = 20

db_multi_az = false

db_skip_final_snapshot = true

db_backup_retention_period = "10"

elasticache_data_storage_maximum = 5

elasticache_ecpu_per_second_maximum = 5000

elasticache_snapshot_retention_limit = 0

elasticache_daily_snapshot_time = null

eks_endpoint_public_access = true

eks_enabled_cluster_log_types = ["api", "audit", "authenticator"]

eks_log_retention_in_days = 7

