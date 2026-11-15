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

## EKS CLUSTER

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "cluster_arn" {
  description = "The ARN of the EKS cluster"
  value       = aws_eks_cluster.main.arn
}

output "cluster_version" {
  description = "The Kubernetes version of the EKS cluster"
  value       = aws_eks_cluster.main.version
}

output "cluster_endpoint" {
  description = "The endpoint of the EKS cluster API server"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority_data" {
  description = "The base64 encoded certificate authority data of the EKS cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
  sensitive   = true
}

output "cluster_security_group_id" {
  description = "The ID of the security group created by EKS for the cluster (control plane and nodes)"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

output "cluster_additional_security_group_id" {
  description = "The ID of the additional security group attached to the cluster by this code"
  value       = aws_security_group.cluster.id
}

output "cluster_iam_role_arn" {
  description = "The ARN of the IAM role used by the EKS control plane"
  value       = aws_iam_role.cluster.arn
}

output "cluster_log_group_name" {
  description = "The name of the CloudWatch log group of the control plane logs"
  value       = aws_cloudwatch_log_group.cluster.name
}

output "cluster_oidc_issuer_url" {
  description = "The OIDC issuer URL of the EKS cluster"
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "oidc_provider_arn" {
  description = "The ARN of the IAM OIDC provider of the cluster (used by IRSA roles)"
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "update_kubeconfig_command" {
  description = "Command to point kubectl at the EKS cluster"
  value       = "aws eks update-kubeconfig --name ${aws_eks_cluster.main.name} --region ${var.aws_region}"
}

## EKS NODE GROUP

output "node_group_id" {
  description = "The ID of the EKS node group (cluster:node-group)"
  value       = aws_eks_node_group.default.id
}

output "node_group_arn" {
  description = "The ARN of the EKS node group"
  value       = aws_eks_node_group.default.arn
}

output "node_group_status" {
  description = "The status of the EKS node group"
  value       = aws_eks_node_group.default.status
}

output "node_group_role_arn" {
  description = "The ARN of the IAM role used by the worker nodes"
  value       = aws_iam_role.node_group.arn
}

output "node_group_autoscaling_group_names" {
  description = "The names of the Auto Scaling Groups behind the node group"
  value       = flatten([for r in aws_eks_node_group.default.resources : r.autoscaling_groups[*].name])
}

## EKS ADD-ONS

output "eks_addon_versions" {
  description = "The installed version of each EKS add-on"
  value = merge(
    { for name, addon in aws_eks_addon.main : name => addon.addon_version },
    { (aws_eks_addon.csi_driver.addon_name) = aws_eks_addon.csi_driver.addon_version }
  )
}

output "ebs_csi_driver_role_arn" {
  description = "The ARN of the IRSA role assumed by the EBS CSI controller"
  value       = aws_iam_role.eks_addon_csi_driver.arn
}

output "storage_class_default" {
  description = "The name of the default StorageClass"
  value       = kubernetes_storage_class_v1.gp3.metadata[0].name
}

## AWS LOAD BALANCER CONTROLLER

output "alb_controller_role_arn" {
  description = "The ARN of the IRSA role assumed by the AWS Load Balancer Controller"
  value       = aws_iam_role.alb_controller.arn
}

output "alb_controller_policy_arn" {
  description = "The ARN of the IAM policy of the AWS Load Balancer Controller"
  value       = aws_iam_policy.alb_controller.arn
}

output "alb_controller_release" {
  description = "Chart version and status of the AWS Load Balancer Controller Helm release"
  value = {
    chart_version = helm_release.alb_controller.version
    status        = helm_release.alb_controller.status
    app_version   = helm_release.alb_controller.metadata.app_version
  }
}
