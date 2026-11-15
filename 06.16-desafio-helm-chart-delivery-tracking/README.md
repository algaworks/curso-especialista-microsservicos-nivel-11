# 6.16 · Desafio: Helm chart do delivery-tracking (resolução)

Enunciado em [`docs/desafio.md`](docs/desafio.md) (versão da plataforma: `docs/desafio-aw.md`).

O código OpenTofu é o da `06.15`, sem mudança: o cluster, o AWS Load Balancer Controller e o certificado do ACM
já estão no ar. **Este desafio não mexe em OpenTofu.** Todo o trabalho é Helm, com o CLI, como na 6.09.

```
k8s/delivery-tracking/                       ponto de partida: os 6 manifestos crus da 5.22
k8s/helm/postgres/                           o chart do Postgres da 6.09 (reaproveitado, sem mudanca)
k8s/helm/postgres-values-override.yaml       corrige a imagem do Postgres
k8s/helm/delivery-tracking/                  RESOLUCAO: o chart do delivery-tracking
k8s/helm/delivery-tracking-values-override.yaml
```

## O que mudou dos manifestos para o chart

| Manifesto da 5.22 | No chart |
|---|---|
| porta `8080` em 4 lugares | `values.port`, num lugar só; probes e Service usam a porta **nomeada** `http` |
| `replicas: 2` + HPA | sem `replicas` quando `autoscaling.enabled`: quem decide é o HPA |
| `image: delivery-tracking:v1.0.0` (local, `kind load`) | `image.repository` / `image.tag`: imagem do Docker Hub |
| `DB_PASSWORD: postgres` no YAML | `database.password` sem padrão, com `required`: o install falha se esquecer |
| `ingressClassName: traefik`, `name: algadelivery` | `alb`, nome próprio, `group.name: algadelivery`, HTTPS com o certificado do ACM |
| `KAFKA_BOOTSTRAP_SERVERS: kafka-0.kafka:9092` | sai; `SPRING_KAFKA_ADMIN_AUTOCREATE=false` (não há Kafka no cluster) |
| ConfigMap/Secret mudou, Pod não reinicia | `checksum/config` e `checksum/secret` no template do Pod forçam o rollout |

## Resolução

```bash
# 0. O tofu output (passo 3) precisa do backend inicializado. O dev.tfvars fica fora do Git:
#    crie o seu a partir do modelo e troque o cloudflare_zone_id pelo da sua zona.
cp example.tfvars dev.tfvars
tofu init -reconfigure -var-file=dev.tfvars

aws eks update-kubeconfig --name development-algadelivery-cluster --region us-east-1
cd k8s/helm

# 1. Conferir antes de instalar
helm lint delivery-tracking --set database.password=x
helm template delivery-tracking delivery-tracking -f delivery-tracking-values-override.yaml | less

# 2. Banco primeiro: o chart da 6.09, com a imagem corrigida
helm install postgres postgres -n algadelivery --create-namespace \
  -f postgres-values-override.yaml --wait

# 3. A aplicacao, com o certificado lido do OpenTofu
helm install delivery-tracking delivery-tracking -n algadelivery \
  -f delivery-tracking-values-override.yaml \
  --set-string "ingress.annotations.alb\.ingress\.kubernetes\.io/certificate-arn=$(cd ../.. && tofu output -raw acm_certificate_arn)" \
  --wait --timeout 10m
```

## Prova

```bash
helm list -n algadelivery                          # duas releases: postgres e delivery-tracking
kubectl get pods,svc,hpa,ingress -n algadelivery   # HPA com percentual, nao <unknown>
curl https://delivery-tracking.dev.algadelivery.com.br/actuator/health

# O Flyway criou as tabelas no deliverydb
kubectl exec -n algadelivery postgres-0 -- psql -U postgres -d deliverydb -c '\dt'
```

## Limpeza (obrigatória antes da 6.17)

Na 6.17 quem instala é o OpenTofu, com o **mesmo** namespace e o **mesmo** nome de release. Se estas releases
ficarem, o `helm_release` falha com `cannot re-use a name that is still in use`.

```bash
helm uninstall delivery-tracking postgres -n algadelivery
kubectl delete pvc -l app=postgres -n algadelivery     # o uninstall NAO apaga PVC (6.09)
kubectl delete namespace algadelivery
```
