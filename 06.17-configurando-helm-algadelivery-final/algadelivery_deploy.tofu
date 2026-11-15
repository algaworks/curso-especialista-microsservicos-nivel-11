# Deploy do AlgaDelivery no EKS: o chart local do delivery-tracking, instalado
# pelo Helm provider. Nada de "helm install" na mao: quem aperta o botao e o
# helm_release, e a release fica no state junto com o resto da infra.
#
# O que este arquivo junta:
#   namespace  -> kubernetes_namespace_v1
#   banco      -> endpoint do module.database + senha do Secrets Manager
#   HTTPS      -> ARN do certificado do module.acm
#   ALB        -> o AWS Load Balancer Controller do module.eks le o Ingress
#
# O Kafka (MSK) fica fora desta aula: o MSK Serverless so aceita autenticacao
# IAM, e a aplicacao ainda nao tem a lib aws-msk-iam-auth.

resource "kubernetes_namespace_v1" "algadelivery" {
  metadata {
    name = var.algadelivery.namespace

    labels = {
      "app.kubernetes.io/part-of" = "algadelivery"
    }
  }

  depends_on = [module.eks]
}

# O RDS foi criado com manage_master_user_password = true: a senha nao esta no
# state nem em variavel, esta no Secrets Manager. Lemos de la, na hora do apply.
data "aws_secretsmanager_secret_version" "db_master" {
  secret_id = module.database.db_password_secret_arn
}

locals {
  db_master_credentials = jsondecode(data.aws_secretsmanager_secret_version.db_master.secret_string)

  # db_endpoint ja vem como host:porta
  delivery_tracking_db_url = "jdbc:postgresql://${module.database.db_endpoint}/${var.db_name}"
}

resource "helm_release" "delivery_tracking" {
  name      = "delivery-tracking"
  namespace = kubernetes_namespace_v1.algadelivery.metadata[0].name
  chart     = "${path.module}/k8s/helm/delivery-tracking"

  # So o que depende da infra. O resto continua vindo do values.yaml do chart.
  values = [
    yamlencode({
      image = {
        repository = var.algadelivery.delivery_tracking.image_repository
        tag        = var.algadelivery.delivery_tracking.image_tag
      }

      database = {
        url      = local.delivery_tracking_db_url
        username = local.db_master_credentials.username
      }

      ingress = {
        host = var.algadelivery.delivery_tracking.host
        annotations = {
          "alb.ingress.kubernetes.io/certificate-arn" = module.acm.certificate_arn
        }
      }
    })
  ]

  # A senha vai separada: set_sensitive nao aparece no plan nem no log.
  set_sensitive = [
    {
      name  = "database.password"
      value = local.db_master_credentials.password
    }
  ]

  # O apply so termina com os Pods prontos (readinessProbe passando).
  # Spring Boot + Flyway no primeiro boot demora: 10 min de folga.
  wait    = true
  timeout = 600

  depends_on = [
    module.eks,      # o AWS Load Balancer Controller precisa existir para o Ingress
    module.database, # o banco precisa aceitar conexao antes do primeiro Pod
  ]
}
