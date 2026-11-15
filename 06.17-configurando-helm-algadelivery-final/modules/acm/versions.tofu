# Diferente dos outros modulos, este precisa declarar o provider: a Cloudflare
# nao e "hashicorp/". Sem este bloco, o modulo procuraria hashicorp/cloudflare,
# que nao existe. A versao fica so na raiz (providers.tofu).
terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}
