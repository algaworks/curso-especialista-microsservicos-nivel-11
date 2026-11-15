# 6.17 · Configurando o Helm do AlgaDelivery com OpenTofu (ponto de partida)

O código OpenTofu é o da `06.15`. O chart do `delivery-tracking` é a resolução do desafio da `06.16`:

```
k8s/helm/delivery-tracking/
├── Chart.yaml
├── values.yaml
└── templates/   configmap, secret, deployment, service, ingress, hpa
```

Na 6.16 o chart foi instalado com o **Helm CLI**, com o banco vindo do chart do Postgres da 6.09, dentro do
cluster. O "botão" era seu.

## O que esta aula faz

Troca o `helm install` pelo **`helm_release` do OpenTofu**, num arquivo novo, `algadelivery_deploy.tofu`, e
liga o chart à infra real:

| Na 6.16 (Helm CLI) | Na 6.17 (OpenTofu) |
|---|---|
| `helm install` na mão | `helm_release`, com a release no state |
| `--create-namespace` | `kubernetes_namespace_v1` |
| Postgres do chart da 6.09, no cluster | **RDS**, `module.database.db_endpoint` |
| senha no `values-override.yaml` | senha do **Secrets Manager** do RDS, por `set_sensitive` |
| ARN do certificado por `$(tofu output ...)` | `module.acm.certificate_arn` direto |

O resultado está em `06.17-configurando-helm-algadelivery-final/`.

## Valores do ambiente

O `dev.tfvars` fica fora do Git. Crie o seu a partir do modelo e troque o `cloudflare_zone_id` pelo da sua zona:

```bash
cp example.tfvars dev.tfvars
```

## Token da Cloudflare

Não fica no `dev.tfvars`:

```bash
read -s TF_VAR_cloudflare_api_token && export TF_VAR_cloudflare_api_token
```
