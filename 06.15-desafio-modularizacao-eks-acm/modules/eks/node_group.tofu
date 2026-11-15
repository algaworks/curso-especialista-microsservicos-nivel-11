resource "aws_iam_role" "node_group" {
  name = "${var.environment}-${var.cluster_name}-ng-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "node_group_role_attachment" {
  for_each   = toset(var.eks_node_role_policy_arns)
  policy_arn = each.value
  role       = aws_iam_role.node_group.name
}

resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = var.eks_node_group_name
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = var.subnet_ids

  capacity_type  = var.eks_node_group_capacity_type
  instance_types = var.eks_node_group_instance_types
  ami_type       = var.eks_node_group_ami_type
  disk_size      = var.eks_node_group_disk_size

  scaling_config {
    desired_size = var.eks_node_group_scaling.desired_size
    max_size     = var.eks_node_group_scaling.max_size
    min_size     = var.eks_node_group_scaling.min_size
  }

  update_config {
    max_unavailable = var.eks_node_group_max_unavailable
  }

  labels = var.eks_node_group_labels

  tags = merge(
    var.common_tags, {
      "Name" = "${var.environment}-${var.cluster_name}-node-group"
  })

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.node_group_role_attachment,
    aws_eks_cluster.main
  ]
}
