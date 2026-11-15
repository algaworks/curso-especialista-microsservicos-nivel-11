# Desafio 6.16 · Empacotando o delivery-tracking como Helm chart

## Objetivo

Transformar os seis manifestos soltos do `delivery-tracking` (aula 5.22) num **Helm chart** e subir a aplicação
no EKS com o **Helm CLI**, usando como banco o **chart do Postgres que você criou na aula 6.09**.

## Contexto

Na 6.09 você empacotou o Postgres como chart e viu o ciclo completo de uma release: `install`, `upgrade`,
`history`, `uninstall`. O `delivery-tracking` continua como no Kind, em seis arquivos com tudo fixo no YAML:
porta, imagem, senha, classe do Ingress.

```
k8s/delivery-tracking/
├── delivery-tracking.configmap.yaml
├── delivery-tracking.secret.yaml
├── delivery-tracking.deployment.yaml
├── delivery-tracking.service.yaml
├── delivery-tracking.ingress.yaml
└── delivery-tracking.hpa.yaml
```

Esses arquivos foram escritos para o **Kind**. Vários valores ali não fazem sentido no EKS, e o chart é
justamente o lugar para separar o que é **estrutura** (template) do que é **ambiente** (values).

Na aula 6.17, quem vai instalar este chart é o **OpenTofu**, ligado ao RDS. Aqui o "botão" ainda é o seu.

## Ponto de partida

O código da `06.15`: cluster, AWS Load Balancer Controller e certificado do ACM no ar. Na pasta `k8s/` estão os
manifestos crus da 5.22 e o chart do Postgres da 6.09 (`k8s/helm/postgres/`).

## O que você precisa fazer

### 1. Criar o chart `k8s/helm/delivery-tracking/`

- `Chart.yaml`, `values.yaml` e os seis manifestos convertidos em `templates/`.
- Todo valor que muda de ambiente para ambiente vira **value**: imagem, porta, recursos, credenciais do
  banco, host do Ingress, parâmetros do HPA.
- A porta aparece em quatro lugares nos manifestos da 5.22. No chart, ela tem que vir de **um lugar só**.

### 2. Adaptar para o EKS

- **Imagem:** a `delivery-tracking:v1.0.0` era local (`kind load`), e o EKS não tem como baixá-la. Use a
  imagem pública do Docker Hub: **`algaworks/delivery-tracking:1.0.3`**. Repositório e tag viram values.
- **Ingress:** troque o Traefik pelo **ALB**, com HTTPS e o certificado do ACM da 6.14, no mesmo
  `group.name` dos Ingress que você já tem. Host: `delivery-tracking.dev.<seu-dominio>`.
- **Kafka:** não há Kafka no EKS ainda. A aplicação tem que subir sem ele.
- **Senha:** não pode ter padrão no `values.yaml`. Se alguém esquecer de passar, o `install` tem que falhar,
  e não subir com senha vazia.

### 3. Subir o banco com o chart da 6.09

Instale o Postgres com o seu próprio chart, no namespace `algadelivery`. **Não** mude o chart: o que precisar
mudar entra por um arquivo de override.

### 4. Instalar o `delivery-tracking`

Com o Helm CLI, no mesmo namespace, apontando para o Postgres do passo anterior.

### 5. Provar que funcionou

Não vale "a release ficou `deployed`". A prova é a aplicação respondendo pelo ALB, com HTTPS.

### 6. Limpar

Na 6.17 o OpenTofu vai instalar o mesmo chart, no mesmo namespace, com o mesmo nome de release. Deixe o
cluster como encontrou.

## Atenção

- **O chart do Postgres tem uma armadilha.** Olhe o `image` do `values.yaml` dele antes de instalar e pergunte-se
  se essa imagem existe no Docker Hub.
- **A senha tem que bater.** O `delivery-tracking` conecta com a senha que o chart do Postgres gravou no
  primeiro boot do volume. Mudar a senha depois não muda o banco.
- **O Ingress não pode se chamar `algadelivery`.** No ALB, quem junta os Ingress é o `group.name`. Reusar o
  nome de outro Ingress apaga a regra dele, e o `apply` responde `configured` sem avisar.
- **Com HPA, o Deployment não tem `replicas`.** Senão, a cada `helm upgrade` o Deployment volta para o número
  fixo e briga com o HPA.
- **Banco antes da aplicação.** Sem o Postgres pronto, o Flyway falha no boot e o Pod entra em
  `CrashLoopBackOff`.

## Critério de aceite

- [ ] `helm lint k8s/helm/delivery-tracking` passa
- [ ] `helm template` sem a senha **falha** com uma mensagem clara
- [ ] a porta do container aparece em **um** lugar no `values.yaml`
- [ ] `helm list -n algadelivery` mostra as releases `postgres` e `delivery-tracking`, `deployed`
- [ ] o Deployment renderizado **não tem** o campo `replicas`
- [ ] `kubectl get hpa -n algadelivery` mostra um percentual em `TARGETS`, e não `<unknown>`
- [ ] `curl https://delivery-tracking.dev.<seu-dominio>/actuator/health` responde `{"status":"UP"...}`
- [ ] as tabelas do Flyway existem no `deliverydb`
- [ ] no fim, o namespace `algadelivery` foi removido, **com** os PVCs

## Dicas (leia se travar)

<details>
<summary>Como ver o YAML que o chart gera, sem instalar?</summary>

`helm template <release> <chart> -f <override>`. É o mesmo comando que você usou na 6.09 para ler o chart do
AWS Load Balancer Controller.
</details>

<details>
<summary>Como fazer o install falhar sem a senha?</summary>

Procure a função `required` dos templates do Helm.
</details>

<details>
<summary>Como passar o ARN do certificado sem colar no arquivo?</summary>

Ele já é output do OpenTofu (`tofu output -raw acm_certificate_arn`). O `--set-string` do Helm aceita
`$( ... )`. Os pontos da chave da anotação precisam de `\.`.
</details>

<details>
<summary>Como fazer o <code>for</code> das variáveis do ConfigMap?</summary>

`{{ range $key, $value := .Values.config }}`. Use `| quote`: no ConfigMap, todo valor é string.
</details>

<details>
<summary>A aplicação fica tentando conectar no Kafka no boot</summary>

É o `KafkaAdmin` tentando criar o tópico. A propriedade `spring.kafka.admin.auto-create` desliga isso. Lembre
a regra do Spring para virar variável de ambiente: ponto vira `_`, hífen some, tudo maiúsculo.
</details>

<details>
<summary>Mudei o ConfigMap com <code>helm upgrade</code> e o Pod continua com o valor antigo</summary>

Variável de ambiente só é lida quando o container sobe. Pesquise o padrão `checksum/config` com `sha256sum`
no template do Pod.
</details>

## Desafio extra (opcional)

Faça um `helm upgrade` mudando só o `autoscaling.minReplicas` e depois um `helm rollback`. Responda: qual
recurso mudou em cada revisão (`helm history`)? Os Pods reiniciaram? Por quê?
