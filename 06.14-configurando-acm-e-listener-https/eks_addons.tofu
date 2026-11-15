resource "aws_eks_addon" "main" {
  for_each = var.eks_addons

  cluster_name  = aws_eks_cluster.main.name
  addon_name    = each.key
  addon_version = each.value.version

  tags = merge(
    local.common_tags, {
      "Name" = "${var.environment}-${var.cluster_name}-addon-${each.key}"
  })

  depends_on = [
    aws_eks_cluster.main,
  ]
}


resource "aws_eks_addon" "csi_driver" {
  cluster_name  = aws_eks_cluster.main.name
  addon_name    = var.eks_addon_csi_driver.name
  addon_version = var.eks_addon_csi_driver.version

  service_account_role_arn = aws_iam_role.eks_addon_csi_driver.arn

  tags = merge(
    local.common_tags, {
      "Name" = "${var.environment}-${var.cluster_name}-addon-aws-ebs-csi-driver"
  })

  depends_on = [
    aws_eks_cluster.main,
  ]
}

data "tls_certificate" "oidc" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc.certificates[0].sha1_fingerprint]

  tags = merge(
    local.common_tags, {
      "Name" = "${var.environment}-${var.cluster_name}-oidc"
  })
}

resource "aws_iam_role" "eks_addon_csi_driver" {
  name = "${var.environment}-${var.cluster_name}-addon-${var.eks_addon_csi_driver.name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${local.oidc_issuer_url}:sub" = "system:serviceaccount:${var.eks_addon_csi_driver.namespace}:${var.eks_addon_csi_driver.serviceaccount}"
            "${local.oidc_issuer_url}:aud" = "sts.amazonaws.com"
          }
        }
      },
    ]
  })

  tags = merge(
    local.common_tags, {
      "Name" = "${var.environment}-role-eks-addon-${var.eks_addon_csi_driver.name}"
  })
}

resource "aws_iam_role_policy_attachment" "eks_addon_csi_driver" {
  role       = aws_iam_role.eks_addon_csi_driver.name
  policy_arn = var.eks_addon_csi_driver.iam_policy_arn

  depends_on = [
    aws_iam_role.eks_addon_csi_driver,
  ]
}



