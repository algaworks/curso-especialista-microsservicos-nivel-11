## CONTEXTO

variable "environment" {
  description = "The environment name (development, homolog, production)"
  type        = string
}

variable "aws_region" {
  description = "The AWS region, used by the AWS Load Balancer Controller"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

## REDE

variable "vpc_id" {
  description = "The ID of the VPC where the cluster lives"
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the private subnets for the control plane ENIs and the nodes"
  type        = list(string)
}

variable "cluster_public_access_cidrs" {
  description = "CIDR blocks allowed to reach the public endpoint of the cluster API"
  type        = list(string)
}

## EKS CLUSTER

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "The version of the EKS cluster"
  type        = string
}

variable "cluster_authentication_mode" {
  description = "The authentication mode for the EKS cluster"
  type        = string
}

variable "cluster_bootstrap_cluster_creator_admin_permissions" {
  description = "Whether to grant admin permissions to the bootstrap cluster creator"
  type        = bool
}

variable "cluster_endpoint_access" {
  description = "The endpoint access configuration for the EKS cluster"
  type = object({
    public  = bool
    private = bool
  })
}

variable "cluster_upgrade_policy_support_type" {
  description = "The support type for the EKS cluster upgrade policy"
  type        = string
}

variable "cluster_log_types" {
  description = "The types of logs to enable for the EKS cluster"
  type        = list(string)
}

variable "cluster_log_retention_in_days" {
  description = "The number of days to retain the EKS cluster logs"
  type        = number
}

variable "cluster_bootstrap_self_managed_addons" {
  description = "Whether to bootstrap self-managed add-ons for the EKS cluster"
  type        = bool
}

## EKS NODE GROUP

variable "eks_node_group_name" {
  description = "The name of the EKS node group"
  type        = string
}

variable "eks_node_group_scaling" {
  description = "The scaling configuration for the EKS node group"
  type = object({
    desired_size = number
    max_size     = number
    min_size     = number
  })
}

variable "eks_node_group_max_unavailable" {
  description = "The maximum number of unavailable nodes during an update for the EKS node group"
  type        = number
}

variable "eks_node_group_instance_types" {
  description = "The instance types for the EKS node group"
  type        = list(string)
}

variable "eks_node_group_capacity_type" {
  description = "The capacity type for the EKS node group (SPOT or ON_DEMAND)"
  type        = string
}

variable "eks_node_group_ami_type" {
  description = "The AMI type for the EKS node group"
  type        = string
}

variable "eks_node_group_disk_size" {
  description = "The disk size in GiB for the EKS node group"
  type        = number
}

variable "eks_node_group_labels" {
  description = "The labels to apply to the EKS node group"
  type        = map(string)
}

variable "eks_node_role_policy_arns" {
  description = "The ARNs of the IAM policies to attach to the EKS node group role"
  type        = list(string)
}

## EKS ADD-ONS

variable "eks_addons" {
  description = "A map of EKS add-ons to be created"
  type = map(object({
    version = optional(string)
  }))
}

variable "eks_addon_csi_driver" {
  description = "Configuration for the EKS add-on for the AWS EBS CSI driver"
  type = object({
    version        = string
    name           = string
    serviceaccount = string
    namespace      = string
    iam_policy_arn = string
  })
}

## AWS LOAD BALANCER CONTROLLER

variable "alb_controller" {
  description = "Configuration for the AWS Load Balancer Controller"
  type = object({
    name           = string
    serviceaccount = string
    repository     = string
    chart          = string
    chart_version  = string
    namespace      = string
    policyName     = string
  })
}
