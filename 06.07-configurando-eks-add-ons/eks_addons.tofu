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