resource "aws_security_group" "cluster" {
  name        = "${var.environment}-${var.cluster_name}-sg"
  description = "Security group for EKS cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = local.eks_api_port
    to_port     = local.eks_api_port
    protocol    = "tcp"
    cidr_blocks = var.cluster_public_access_cidrs
  }
}
