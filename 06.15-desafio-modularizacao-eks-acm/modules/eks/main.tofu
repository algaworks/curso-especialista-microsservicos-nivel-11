resource "aws_eks_cluster" "main" {
  name     = "${var.environment}-${var.cluster_name}-cluster"
  version  = var.cluster_version
  role_arn = aws_iam_role.cluster.arn

  bootstrap_self_managed_addons = var.cluster_bootstrap_self_managed_addons

  access_config {
    authentication_mode                         = var.cluster_authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.cluster_bootstrap_cluster_creator_admin_permissions
  }

  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = [aws_security_group.cluster.id]
    endpoint_private_access = var.cluster_endpoint_access.private
    endpoint_public_access  = var.cluster_endpoint_access.public
    public_access_cidrs     = var.cluster_public_access_cidrs
  }

  upgrade_policy {
    support_type = var.cluster_upgrade_policy_support_type
  }

  enabled_cluster_log_types = var.cluster_log_types

  tags = merge(
    var.common_tags, {
      "Name" = "${var.environment}-${var.cluster_name}-cluster"
  })

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster,
    aws_cloudwatch_log_group.cluster
  ]
}

resource "aws_iam_role" "cluster" {
  name = "${var.environment}-${var.cluster_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_cloudwatch_log_group" "cluster" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.cluster_log_retention_in_days

  tags = merge(
    var.common_tags, {
      "Name" = "${var.environment}-${var.cluster_name}-logs"
  })
}
