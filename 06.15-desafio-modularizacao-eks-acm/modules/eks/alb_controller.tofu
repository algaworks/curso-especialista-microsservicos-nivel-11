resource "aws_iam_policy" "alb_controller" {
  name        = var.alb_controller.policyName
  description = "IAM policy for ALB Ingress Controller"
  # path.module agora aponta para modules/eks/, e e la que o JSON mora.
  policy = file("${path.module}/policy/iam_policy.json")

  tags = merge(
    var.common_tags,
    {
      Name = var.alb_controller.policyName
    }
  )
}

resource "aws_iam_role" "alb_controller" {
  name = "${var.environment}-${var.cluster_name}-alb-controller-role"

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
            "${local.oidc_issuer_url}:sub" = "system:serviceaccount:${var.alb_controller.namespace}:${var.alb_controller.serviceaccount}"
            "${local.oidc_issuer_url}:aud" = "sts.amazonaws.com"
          }
        }
      },
    ]
  })

  tags = merge(
    var.common_tags, {
      "Name" = "${var.environment}-${var.cluster_name}-alb-controller-role"
    }
  )
}

resource "aws_iam_role_policy_attachment" "alb_controller" {
  role       = aws_iam_role.alb_controller.name
  policy_arn = aws_iam_policy.alb_controller.arn

  depends_on = [
    aws_iam_role.alb_controller,
  ]
}

resource "helm_release" "alb_controller" {
  name       = var.alb_controller.name
  namespace  = var.alb_controller.namespace
  repository = var.alb_controller.repository
  chart      = var.alb_controller.chart
  version    = var.alb_controller.chart_version

  values = [
    yamlencode({
      clusterName = aws_eks_cluster.main.name
      region      = var.aws_region
      vpcId       = var.vpc_id
      serviceAccount = {
        create = true
        name   = var.alb_controller.serviceaccount
        annotations = {
          "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller.arn
        }
      }
    })
  ]

  depends_on = [
    aws_iam_role_policy_attachment.alb_controller,
    aws_iam_role.alb_controller,
    aws_iam_policy.alb_controller
  ]
}
