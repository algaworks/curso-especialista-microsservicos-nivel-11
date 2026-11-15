resource "kubernetes_namespace_v1" "delivery_tracking" {
  metadata {
    name = var.delivery_tracking_helm_values.namespace

    labels = {
      "app.kubernetes.io/name" = var.delivery_tracking_helm_values.namespace
    }
  }

  depends_on = [module.eks]
}

data "aws_secretsmanager_secret_version" "db_master" {
    secret_id = module.database.db_password_secret_arn

    depends_on = [module.database]
}

locals {
    db_credentials = jsondecode(data.aws_secretsmanager_secret_version.db_master.secret_string)
    delivery_tracking_db_url = "jdbc:postgresql://${module.database.db_endpoint}/${var.db_name}"
}

resource "helm_release" "delivery_tracking" {
  name       = var.delivery_tracking_helm_values.namespace
  namespace  = kubernetes_namespace_v1.delivery_tracking.metadata[0].name
  chart      = "${path.module}/k8s/helm/${var.delivery_tracking_helm_values.namespace}"

  values = [
    yamlencode({
      image = {
        repository = var.delivery_tracking_helm_values.image_repository
        tag        = var.delivery_tracking_helm_values.image_tag
      }

      database = {
        url      = local.delivery_tracking_db_url
        username = local.db_credentials.username
      }

      ingress = {
        host = var.delivery_tracking_helm_values.ingress_host
        annotations = {
          "alb.ingress.kubernetes.io/certificate-arn" = module.acm.certificate_arn
        }
      }
    })
  ]

  set_sensitive = [
    {
      name  = "database.password"
      value = local.db_credentials.password
    }
  ]

  wait = true
  timeout = "300"
  

  depends_on = [
    module.database,
    module.acm,
    kubernetes_namespace_v1.delivery_tracking
  ]

}

