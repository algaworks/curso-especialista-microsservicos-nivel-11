# 6.17 · Configurando o Helm do AlgaDelivery com OpenTofu (final)

O chart do `delivery-tracking` (resolução do desafio da 6.16), agora instalado no EKS pelo **Helm provider do
OpenTofu** e ligado à infra real: RDS no lugar do Postgres do cluster, senha do Secrets Manager e certificado
do `module.acm`.

```
k8s/helm/delivery-tracking/          o chart da 6.16, sem mudanca
├── Chart.yaml
├── values.yaml                      padroes; o OpenTofu sobrescreve o que depende da infra
└── templates/
    ├── delivery-tracking.configmap.yaml
    ├── delivery-tracking.secret.yaml
    ├── delivery-tracking.deployment.yaml
    ├── delivery-tracking.service.yaml
    ├── delivery-tracking.ingress.yaml
    └── delivery-tracking.hpa.yaml

algadelivery_deploy.tofu             namespace + leitura da senha do RDS + helm_release
```

## Como os dados chegam ao chart

| Value do chart | De onde vem |
|---|---|
| `image.repository` / `image.tag` | `var.algadelivery.delivery_tracking` (`dev.tfvars`) |
| `database.url` | `module.database.db_endpoint` + `var.db_name` |
| `database.username` / `database.password` | **Secrets Manager** do RDS (`manage_master_user_password`), lido por `data "aws_secretsmanager_secret_version"`. A senha vai por `set_sensitive` |
| `ingress.host` | `var.algadelivery.delivery_tracking.host` |
| `ingress.annotations.certificate-arn` | `module.acm.certificate_arn` |
| o resto (probes, resources, HPA, ALB) | `values.yaml` do chart |

## Antes do apply

1. **Valores do ambiente.** O `dev.tfvars` fica fora do Git. Crie o seu a partir do modelo e troque o
   `cloudflare_zone_id` pelo da sua zona:
   ```bash
   cp example.tfvars dev.tfvars
   ```
2. **Imagem.** `algaworks/delivery-tracking:1.0.3`, do Docker Hub (público, multi-arch: `amd64` + `arm64`). Para outra versão, troque o
   `image_tag` no `dev.tfvars`.
3. **Token da Cloudflare**, fora do tfvars:
   ```bash
   read -s TF_VAR_cloudflare_api_token && export TF_VAR_cloudflare_api_token
   ```
4. **Limpeza da 6.16 feita.** Se as releases `postgres`/`delivery-tracking` ou o namespace `algadelivery`
   ainda existirem, o apply falha (`cannot re-use a name` / namespace já existe).
5. **Os Ingress manuais do grupo `algadelivery`** (`k8s/ingress-https.yaml`) podem continuar: todos
   entram no mesmo ALB.

## Apply

```bash
tofu init -reconfigure -var-file=dev.tfvars

# So o que o deploy precisa: EKS, ACM, RDS, namespace e a release.
# Sem o -target, o apply tambem cria bastion, ElastiCache e MSK, que custam por hora e esta aula nao usa.
tofu apply -var-file=dev.tfvars -target=helm_release.delivery_tracking
```

O RDS leva ~10 min no primeiro apply. Depois, o `helm_release` espera os Pods ficarem prontos (`wait = true`,
até 10 min): Spring Boot + Flyway criando as tabelas no primeiro boot.

## Conferir

```bash
aws eks update-kubeconfig --name development-algadelivery-cluster --region us-east-1

helm list -n algadelivery                       # a release que o OpenTofu instalou
kubectl get pods,svc,hpa,ingress -n algadelivery
curl https://delivery-tracking.dev.algadelivery.com.br/actuator/health
```

`*.dev.algadelivery.com.br` já aponta para o ALB do grupo `algadelivery` (CNAME na Cloudflare), e o
certificado wildcard do ACM cobre o host.

## Cuidados

- **Kafka fora.** O MSK Serverless só aceita autenticação IAM, e a aplicação ainda não tem a lib
  `aws-msk-iam-auth`. A API sobe; o que publica evento falha. O `SPRING_KAFKA_ADMIN_AUTOCREATE=false` evita
  que o boot fique tentando criar o tópico.
- **Mudou um template? Suba o `version` do `Chart.yaml`.** O `helm_release` detecta mudança no chart local
  pela versão. Mudança só de template, com a mesma versão, pode passar despercebida no plan.
- **A senha do RDS gira sozinha.** O Secrets Manager do RDS roda a senha a cada 7 dias por padrão. O Secret do
  Kubernetes guarda a senha da época do último `apply`. O próximo `apply` relê o Secrets Manager, o
  `checksum/secret` muda e os Pods reiniciam com a senha nova. Até lá, a conexão quebra. Ler o segredo direto
  do cluster é assunto do Módulo 8.
- **Destroy.** A release está no state, e o Ingress dela é removido antes do controller (`depends_on`). Os
  Ingress criados com `kubectl` não estão: o ritual continua `kubectl delete ingress --all -A` → esperar o
  ALB sumir → `tofu destroy`.
