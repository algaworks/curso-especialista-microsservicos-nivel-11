output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.vpc.vpc_arn
}

output "subnet_public_ids" {
  description = "The IDs of the public subnets"
  value       = module.vpc.subnet_pub_ids["public"]
}

output "subnet_public_arn" {
  description = "The ARNs of the public subnets"
  value       = module.vpc.subnet_pub_arns["public"]
}

output "subnet_pvt_mgmt_ids" {
  description = "The IDs of the private management subnets"
  value       = module.vpc.subnet_pvt_ids["management"]
}

output "subnet_pvt_mgmt_arns" {
  description = "The ARNs of the private management subnets"
  value       = module.vpc.subnet_pvt_arns["management"]
}

output "subnet_pvt_cluster_id" {
  description = "The IDs of the private cluster subnets"
  value       = module.vpc.subnet_pvt_ids["cluster"]
}

output "subnet_pvt_cluster_arn" {
  description = "The ARNs of the private cluster subnets"
  value       = module.vpc.subnet_pvt_arns["cluster"]
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc.igw_id
}

output "igw_arn" {
  description = "The ARN of the Internet Gateway"
  value       = module.vpc.igw_arn
}

output "ngw_id" {
  description = "The ID of the NAT Gateway"
  value       = module.vpc.ngw_id
}

output "route_table_public_id" {
  description = "The ID of the public route table"
  value       = module.vpc.route_table_public_id
}

output "route_table_private_id" {
  description = "The ID of the private route table"
  value       = module.vpc.route_table_private_id
}

output "bastion_id" {
  description = "The ID of the bastion instance"
  value       = module.bastion.id
}

output "bastion_arn" {
  description = "The ARN of the bastion instance"
  value       = module.bastion.arn
}

output "bastion_public_ip" {
  description = "The public IP of the bastion instance"
  value       = module.bastion.public_ip
}

output "keypair_arn" {
  description = "The ARN of the key pair"
  value       = module.bastion.keypair_arn
}

output "security_group_bastion_id" {
  description = "The ID of the bastion security group"
  value       = module.bastion.security_group_id
}

output "db_password_secret_arn" {
  value = module.database.db_password_secret_arn
}

output "db_endpoint" {
  value = module.database.db_endpoint
}

output "db_instance_id" {
  value = module.database.db_instance_id
}

output "db_instance_arn" {
  value = module.database.db_instance_arn
}

output "elasticache_endpoint_address" {
  description = "The primary endpoint address of the ElastiCache serverless cache"
  value       = module.elasticache.endpoint_address
}

output "elasticache_endpoint_port" {
  description = "The primary endpoint port of the ElastiCache serverless cache"
  value       = module.elasticache.endpoint_port
}

output "elasticache_reader_endpoint_address" {
  description = "The reader endpoint address of the ElastiCache serverless cache"
  value       = module.elasticache.reader_endpoint_address
}

output "elasticache_arn" {
  description = "The ARN of the ElastiCache serverless cache"
  value       = module.elasticache.arn
}

output "security_group_elasticache_id" {
  description = "The ID of the ElastiCache security group"
  value       = module.elasticache.security_group_id
}

output "msk_arn" {
  description = "The ARN of the MSK Serverless cluster"
  value       = module.msk.arn
}

output "msk_bootstrap_brokers_sasl_iam" {
  description = "IAM bootstrap broker endpoints for the MSK Serverless cluster"
  value       = module.msk.bootstrap_brokers_sasl_iam
}

output "security_group_msk_id" {
  description = "The ID of the MSK security group"
  value       = module.msk.security_group_id
}

## EKS (module.eks)

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_arn" {
  value = module.eks.cluster_arn
}

output "cluster_version" {
  value = module.eks.cluster_version
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value     = module.eks.cluster_certificate_authority_data
  sensitive = true
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "cluster_additional_security_group_id" {
  value = module.eks.cluster_additional_security_group_id
}

output "cluster_iam_role_arn" {
  value = module.eks.cluster_iam_role_arn
}

output "cluster_log_group_name" {
  value = module.eks.cluster_log_group_name
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "node_group_id" {
  value = module.eks.node_group_id
}

output "node_group_arn" {
  value = module.eks.node_group_arn
}

output "node_group_status" {
  value = module.eks.node_group_status
}

output "node_group_role_arn" {
  value = module.eks.node_group_role_arn
}

output "node_group_autoscaling_group_names" {
  value = module.eks.node_group_autoscaling_group_names
}

output "ebs_csi_driver_role_arn" {
  value = module.eks.ebs_csi_driver_role_arn
}

output "storage_class_default" {
  value = module.eks.storage_class_default
}

output "alb_controller_role_arn" {
  value = module.eks.alb_controller_role_arn
}

output "alb_controller_policy_arn" {
  value = module.eks.alb_controller_policy_arn
}

output "alb_controller_release" {
  value = module.eks.alb_controller_release
}

output "eks_addon_versions" {
  value = module.eks.addon_versions
}

output "update_kubeconfig_command" {
  description = "Command to point kubectl at the EKS cluster"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_region}"
}


## ACM (module.acm)

output "acm_certificate_arn" {
  value = module.acm.certificate_arn
}

output "acm_domain_name" {
  value = module.acm.domain_name
}

output "acm_validation_record_names" {
  value = module.acm.validation_record_names
}

## ALGADELIVERY

output "algadelivery_namespace" {
  value = kubernetes_namespace_v1.algadelivery.metadata[0].name
}

output "delivery_tracking_url" {
  description = "Public URL of the delivery-tracking (ALB + ACM)"
  value       = "https://${var.algadelivery.delivery_tracking.host}"
}

output "delivery_tracking_release" {
  description = "Chart version and status of the delivery-tracking Helm release"
  value = {
    chart_version = helm_release.delivery_tracking.version
    status        = helm_release.delivery_tracking.status
  }
}
