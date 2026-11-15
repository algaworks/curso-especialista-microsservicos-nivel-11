module "eks" {
  source = "./modules/eks"

  environment = var.environment
  aws_region  = var.aws_region
  common_tags = local.common_tags

  vpc_id                      = module.vpc.vpc_id
  subnet_ids                  = module.vpc.subnet_pvt_ids["cluster"]
  cluster_public_access_cidrs = [local.internet_cidr_block]

  cluster_name                                        = var.cluster_name
  cluster_version                                     = var.cluster_version
  cluster_authentication_mode                         = var.cluster_authentication_mode
  cluster_bootstrap_cluster_creator_admin_permissions = var.cluster_bootstrap_cluster_creator_admin_permissions
  cluster_endpoint_access                             = var.cluster_endpoint_access
  cluster_upgrade_policy_support_type                 = var.cluster_upgrade_policy_support_type
  cluster_log_types                                   = var.cluster_log_types
  cluster_log_retention_in_days                       = var.cluster_log_retention_in_days
  cluster_bootstrap_self_managed_addons               = var.cluster_bootstrap_self_managed_addons

  eks_node_group_name            = var.eks_node_group_name
  eks_node_group_scaling         = var.eks_node_group_scaling
  eks_node_group_max_unavailable = var.eks_node_group_max_unavailable
  eks_node_group_instance_types  = var.eks_node_group_instance_types
  eks_node_group_capacity_type   = var.eks_node_group_capacity_type
  eks_node_group_ami_type        = var.eks_node_group_ami_type
  eks_node_group_disk_size       = var.eks_node_group_disk_size
  eks_node_group_labels          = var.eks_node_group_labels
  eks_node_role_policy_arns      = var.eks_node_role_policy_arns

  eks_addons           = var.eks_addons
  eks_addon_csi_driver = var.eks_addon_csi_driver

  alb_controller = var.alb_controller
}
