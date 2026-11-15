# Exemplo de valores do ambiente. Copie e ajuste antes de usar:
#   cp example.tfvars dev.tfvars     (ou prod.tfvars)
# dev.tfvars e prod.tfvars ficam fora do Git (.gitignore).
#
# Valores do ambiente de desenvolvimento. Uso:
#   tofu init -reconfigure -var-file=dev.tfvars
#   tofu plan -var-file=dev.tfvars
#
# Sem segredos: pode ir para o Git. Segredo vai em TF_VAR_*, nunca aqui.
# Mesma ordem do variables.tofu.

aws_region = "us-east-1"

environment = "development"

## VPC

vpc_cidr_block = "172.25.0.0/16"

vpc_name = "algadelivery-vpc"

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

ngw_regional_mode = true

## BASTION (EC2)

instance_type = "t3.micro"

keypair_name = "algadelivery-bastion"

ami_id = "ami-04680790a315cd58d"

# null = usa o security group padrao montado em local.tofu
bastion_security_group_config = null

## RDS

db_subnet_group_name = "algadelivery-db-subnet-group"

db_parameter_group_name = "algadelivery-db-parameter-group"

db_parameter_group_options = {
  max_connections          = "300"
  shared_preload_libraries = "pg_stat_statements,pgaudit"
}

db_engine = "postgres"

db_engine_version = "18"

db_name = "delivery"

db_instance_class = "db.t4g.micro"

db_username = "postgres"

db_storage = 20

db_multi_az = false

db_skip_final_snapshot = true

db_identifier = "algadelivery-db"

db_port = 5432

# null = usa o security group padrao montado em local.tofu
db_security_group_config = null

db_backup_retention_period = "10"

db_backup_window = "02:00-03:00"

db_maintenance_window = "Mon:03:00-Mon:04:00"

## ELASTICACHE SERVERLESS (Valkey)

elasticache_major_engine_version = "8"

elasticache_data_storage_maximum = 5

elasticache_data_storage_minimum = 1

elasticache_ecpu_per_second_maximum = 5000

elasticache_ecpu_per_second_minimum = 1000

elasticache_snapshot_retention_limit = 0

elasticache_daily_snapshot_time = null

# null = usa o security group padrao montado em local.tofu
elasticache_security_group_config = null

## MSK SERVERLESS

# null = usa o security group padrao montado em local.tofu
msk_security_group_config = null

## EKS CLUSTER

cluster_name = "algadelivery"

cluster_version = "1.37"

cluster_authentication_mode = "API_AND_CONFIG_MAP"

cluster_bootstrap_cluster_creator_admin_permissions = true

cluster_endpoint_access = {
  public  = true
  private = true
}

cluster_upgrade_policy_support_type = "STANDARD"

cluster_log_types = ["api", "authenticator"]

cluster_log_retention_in_days = 7

cluster_bootstrap_self_managed_addons = false

## EKS NODE GROUP

eks_node_group_name = "algadelivery-ng-default"

eks_node_group_scaling = {
  desired_size = 1
  max_size     = 2
  min_size     = 1
}

eks_node_group_max_unavailable = 1

eks_node_group_instance_types = ["t3.medium"]

eks_node_group_capacity_type = "SPOT"

eks_node_group_ami_type = "BOTTLEROCKET_x86_64"

eks_node_group_disk_size = 40

eks_node_group_labels = {
  "environment" = "development"
  "team"        = "delivery"
}

eks_node_role_policy_arns = [
  "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
  "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
  "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
]

## EKS ADD-ONS

eks_addons = {
  vpc-cni = {
    version = "v1.22.4-eksbuild.10"
  }
  kube-proxy = {}
  coredns    = {}
  metrics-server = {
    version = "v0.9.0-eksbuild.14"
  }
}

eks_addon_csi_driver = {
  version        = "v1.67.2-eksbuild.1"
  name           = "aws-ebs-csi-driver"
  serviceaccount = "ebs-csi-controller-sa"
  namespace      = "kube-system"
  iam_policy_arn = "arn:aws:iam::aws:policy/AmazonEBSCSIDriverPolicyV2"
}

## AWS LOAD BALANCER CONTROLLER

alb_controller = {
  name           = "aws-load-balancer-controller"
  serviceaccount = "aws-load-balancer-controller"
  repository     = "https://aws.github.io/eks-charts"
  chart          = "aws-load-balancer-controller"
  chart_version  = "3.6.2"
  namespace      = "kube-system"
  policyName     = "AWSLoadBalancerControllerIAMPolicy"
}

# cloudflare_api_token: NAO coloque aqui. Use: read -s TF_VAR_cloudflare_api_token && export TF_VAR_cloudflare_api_token
domain_name        = "*.dev.algadelivery.com.br"
cloudflare_zone_id = "<seu-zone-id-da-cloudflare>"