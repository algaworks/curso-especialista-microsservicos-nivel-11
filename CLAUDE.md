# CLAUDE.md

Este arquivo orienta o Claude Code (claude.ai/code) ao trabalhar com o código deste repositório.

## Visão geral

Repositório do curso **"Microsserviços em Produção na AWS — Nível 11"** (Algaworks). O projeto prático é o **AlgaDelivery**, uma plataforma de microsserviços implantada na AWS. Cada diretório numerado (ex.: `03.07-trabalhando-com-variaveis/`) é um snapshot autocontido de uma aula específica, construído incrementalmente sobre o anterior. Toda a infraestrutura é escrita em **OpenTofu** (arquivos `.tofu`).

A ementa completa do curso está em `.EMENTA-NIVEL-11-AWS.md` — trate-a como a fonte da verdade para a estrutura de módulos/aulas.

## Estrutura do curso (13 módulos)

| # | Módulo | Status | Aulas |
|---|---|---|---|
| 1 | Fundamentos de Cloud Computing | ✅ finalizado | 7 |
| 2 | Fundamentos de Redes na AWS | ✅ finalizado | 19 |
| 3 | Infraestrutura como Código (IaC) na AWS | ✅ finalizado | 21 |
| 4 | IaC Modular e Serviços Gerenciados na AWS | ✅ finalizado | 21 |
| 5 | Kubernetes: Fundamentos e Workloads | ✅ finalizado | 23 |
| 6 | Provisionando o cluster EKS na AWS com OpenTofu | 📋 ementa planejada | 16 |
| 7 | Ferramentas de Deploy e GitOps | 📋 ementa planejada | 16 |
| 8 | Configuração Externalizada e Gestão de Segredos | 📋 ementa planejada | 10 |
| 9 | Deploy do Backend do AlgaDelivery na AWS | 📋 ementa planejada | 6 |
| 10 | Deploy do Frontend do AlgaDelivery (S3 + CloudFront) | 📋 ementa planejada | 6 |
| 11 | Observabilidade em Produção: Prometheus, Grafana e Elastic APM | 📋 ementa planejada | 19 |
| 12 | Apêndice — Deploy Algashop | 🔜 a planejar | — |

**Arco narrativo:** Fundamentos de cloud → Redes na AWS → Fundamentos de IaC → IaC modular + serviços gerenciados → **Kubernetes completo em cluster local com Kind** (workloads, storage, rede, escala e teste de carga) → **Provisionar EKS** (ALB Ingress + ACM) → Ferramentas de deploy (Helm/ArgoCD) → Configuração externalizada → Deploy do backend do AlgaDelivery em infra real → Deploy do frontend do AlgaDelivery (S3 + CloudFront) → Observá-lo em produção (Prometheus/Grafana + Elastic APM) → Apêndice.

> **Fusão M5 + M6 (decisão do instrutor):** os antigos Módulos 5 (Fundamentos e Workloads) e 6 (Rede, Escala e Segurança) foram **unificados em um único Módulo 5**, e todos os módulos seguintes foram renumerados (−1). O objetivo foi reduzir a contagem total de aulas e deixar o bloco de Kubernetes mais leve. Ver "Conteúdo cortado na fusão M5+M6" em Lacunas conhecidas. O Módulo 5 chegou a ter 26 aulas logo após a fusão; a aula de Services foi depois desmembrada em duas (`5.16` ClusterIP/DNS e `5.17` NodePort/Headless) e as duas aulas de **Grafana k6** foram removidas da ementa (decisão do instrutor). Depois saíram também **Jobs/CronJobs, Lens e Rancher**, e entrou o **desafio `5.23`** (manifestos do Courier Management), fechando em **23 aulas**.

## Princípios pedagógicos

Estes princípios emergiram do design do curso e devem guiar sugestões de conteúdo/código:

1. **Conceito → Implementação** — conceitos abstratos são ensinados imediatamente antes de sua implementação concreta, não separadamente. Quando o conceito é curto demais para um vídeo próprio, ele vira o **bloco de abertura** da aula do primitivo, em vez de uma aula solta:
   - O Módulo 5 abre com Containers vs VMs (`5.01`) e a intro ao K8s (`5.02`) como *construção argumentativa* para "por isso o K8s existe"
   - **Failover** (conceito) abre a aula de **ReplicaSet** (`5.08 ReplicaSet: failover e disponibilidade de Pods`) — as duas eram aulas separadas e foram fundidas: o conceito sozinho não sustentava um vídeo. O bloco de abertura carrega a demo da dor (`kubectl drain --force` num Pod sem `ownerReferences`), o argumento MTTR > MTBF e a disponibilidade em série (0,999⁵ ≈ 99,5%)
   - **Self Healing** (conceito) e **Probes** (o mecanismo que o implementa) foram fundidos numa aula só, `5.18` — o conceito é o bloco de abertura
2. **Console primeiro, depois IaC** — muitos serviços AWS são introduzidos manualmente pelo Console e depois reprovisionados com OpenTofu. Padrão visível no Módulo 4 (RDS, ElastiCache, MSK) e que continua no Módulo 6 (EKS, node groups, add-ons, EBS CSI, ACM).
3. **Sem mini-labs nem desafio no Módulo 1** — o módulo é 100% conceitual (7 aulas, de `1.01` a `1.07 Shared Responsibility Model`). Todo o hands-on começa a partir do Módulo 2, com a criação da conta AWS (`2.02`).
4. **O Módulo 4 tem dois desafios** — `4.16 Desafio: Criando Módulo ElastiCache` e `4.19 Desafio: Modulo MSK`. Padrão: primeiro entregar o serviço hands-on, depois desafiar o aluno a modularizá-lo.
5. **Conceitos de cloud ficam no Módulo 1; primitivos de computação vão para o Módulo 5** — VMs e Containers foram movidos para a abertura do Módulo 5 (`5.01`) para ficarem contíguos ao K8s. O Módulo 1 agora é exclusivamente "o que é cloud + propriedades operacionais + quando migrar". As aulas de **Cloud Native/CNCF** e os três **Service Instance Patterns** foram **removidas**: a pitada de CNCF foi absorvida em 1 slide da `5.02`, e os Service Instance Patterns saíram inteiros (junto com a aula "Aplicando Service Instance per Container com Pods", que fechava aquele arco — não confundir com o `5.21` atual, que é o setup do AlgaDelivery).
6. **Fundamentos de rede ficam no Módulo 2, não duplicados no Módulo 1** — os itens 2.05 (fundamentos de VPC) e 2.06 (CIDR) cobrem IP/DNS/subnets, então o Módulo 1 omite esses tópicos.
7. **Arco de storage contíguo** — volumes efêmeros (`5.11`), PV/PVC/StorageClass (`5.14`) e StatefulSets (`5.15`) são vizinhos porque `volumeClaimTemplates` é incompreensível sem PVC. Os callbacks do Módulo 6 (EBS CSI Driver) e do Módulo 11 (Elasticsearch stateful) seguem válidos.
8. **Labels e Selectors precedem os controllers** — `Namespaces, Labels, Selectors e Annotations` (`5.07`) vem antes porque `selector.matchLabels` é pré-requisito de ReplicaSet (`5.08`), Deployment (`5.09`) e Service (`5.16`).
9. **A aula de integração fecha o primeiro arco** — `5.21 Setup do AlgaDelivery em k8s (api + db)` não ensina primitivo novo: ela obriga o aluno a compor Deployment + StatefulSet + PVC + ConfigMap + Secret + Service + Ingress numa aplicação real, já com probes e `resources`. É o ponto de virada entre "primitivos isolados" e "operar a aplicação" (HPA, Jobs).

### Lacunas conhecidas (intencionais, não omissões)

- **IAM** — sem módulo dedicado, mas com **uma aula de base** (`6.02`, ~15 min) que cobre policy, role, trust policy e STS, porque o Módulo 6 consome tudo isso em código. O aprofundamento (permission boundaries, SCP/Organizations, Access Analyzer, IdP externo) continua fora do escopo; IRSA entra pontualmente na `6.10`.
- **FinOps** — apenas `1.06 Cloud Providers, precificação, Free Tier e Calculadora da AWS` e `2.03 Criando budgets para controle de custo`; sem cobertura mais profunda planejada.

### Conteúdo cortado na fusão M5+M6

Os tópicos abaixo estavam nas ementas antigas dos Módulos 5 e 6 e **não sobreviveram** à unificação. Não são esquecimento — foram cortados para enxugar o bloco de Kubernetes. Registrados aqui porque alguns têm dependentes vivos em módulos posteriores:

| Tópico cortado | Estava em | Dependente que ficou órfão |
|---|---|---|
| Sidecar Pattern | antigo `5.16` | — (o multi-container de `5.06` continua ensinado) |
| DaemonSets | antigo `5.17` | — |
| Node Selector, Affinity e Anti-Affinity | antigo `6.10–6.11` | ⚠️ `11.03` (node group de tooling isolado por affinity) |
| Taints e Tolerations (+ `cordon`/`drain`) | antigo `6.12` | ⚠️ `11.03`; a demo de `drain` de `5.08` (ReplicaSet) |
| PodDisruptionBudget | antigo `6.13` | ⚠️ upgrade de node group no Módulo 6 |
| Service Accounts e RBAC | antigo `6.14` | ⚠️ IRSA em `6.10` (AWS Load Balancer Controller) |

**Onde isso dói:** a aula `11.03 Node group dedicado de tooling` foi escrita como *callback* a taints/tolerations/affinity — sem essas aulas, ela passa a ser a **primeira** apresentação desses conceitos e precisa ensiná-los inline. O mesmo vale para RBAC/ServiceAccount antes do IRSA em `6.08`.

O DNS interno do cluster (antigo `6.02`) foi **absorvido** em `5.16 Services`, e o Headless Service (antigo `6.03`) foi **absorvido** em `5.17 Services` — não cortados.

## Comandos OpenTofu

Todos os comandos usam `tofu`, não `terraform`.

```bash
tofu init       # inicializa providers e módulos
tofu validate   # valida a sintaxe da configuração
tofu fmt -recursive  # formata todos os arquivos .tofu
tofu plan       # prévia das mudanças
tofu apply      # aplica as mudanças
tofu destroy    # destrói todos os recursos
```

Para as aulas do **Módulo 4** com a estrutura multi-ambiente (`envs/dev`, `envs/prod`), execute os comandos de dentro do diretório do ambiente:

```bash
cd <aula>/envs/dev
tofu init
tofu plan
tofu apply
```

**Módulo 6 em diante** (`06.04`, `06.06`, `06.08`, `06.10`, `06.11`, `06.15`, `06.16`): **não há `envs/`**. Cada pasta é um root module único e os comandos rodam **da raiz da pasta da aula**, escolhendo o ambiente por arquivo de valores:

```bash
cd <aula>
cp example.tfvars dev.tfvars                   # dev.tfvars/prod.tfvars ficam fora do Git
tofu init -reconfigure -var-file=dev.tfvars     # -reconfigure ao trocar de ambiente
tofu plan  -var-file=dev.tfvars
tofu apply -var-file=dev.tfvars
tofu destroy -var-file=dev.tfvars              # prod: prod.tfvars
```

`tofu validate` e `tofu fmt` não precisam de `-var-file`. Ver "Decisões de código do módulo" (Módulo 6).

### Progressão das aulas

- **Módulo 3 (03.XX) — Infraestrutura como Código (IaC) na AWS:** fundamentos do OpenTofu + provisionamento de uma rede completa do zero. Estrutura flat, um único diretório com `main.tofu`, `variables.tofu`, `outputs.tofu`, `providers.tofu`. Constrói até: VPC + subnets públicas/privadas + IGW + NAT Gateway + route tables + Security Groups (Bastion + Private) + EC2 (pública + privada), tudo via OpenTofu. Termina com testes de conectividade e destroy.
- **Módulo 4 (04.XX) — IaC Modular e Serviços Gerenciados na AWS:** modularização (dynamic blocks, for expressions, lifecycle) e serviços gerenciados. Introduz `modules/vpc`, `modules/ec2`, `modules/rds`, `modules/elasticache`, `modules/msk`. Estrutura multi-ambiente (`envs/dev`, `envs/prod`) a partir de `04.07-explorando-multi-env`.

### Nomenclatura dos diretórios de aula

Os diretórios seguem `<MM>.<NN>-<titulo-em-kebab-case>/`:
- `03.07-trabalhando-com-variaveis/`
- `04.13-configurando-backup-e-manutencao-no-rds/`

A numeração segue a ementa. Variantes ocasionais `*-final/` indicam o estado "após a correção" de uma aula (ex.: `04.13-configurando-backup-e-manutencao-no-rds-final/`).

### Estrutura final do Módulo 4 (a partir de `04.07-explorando-multi-env`)

```
<aula>/
├── modules/
│   ├── vpc/          # VPC, subnets (públicas/privadas), IGW, NAT Gateway, route tables
│   ├── ec2/          # Key pair (TLS gerado), EIP, instância EC2, security group
│   ├── rds/          # RDS PostgreSQL: parameter groups, backup, janela de manutenção, senha segura
│   ├── elasticache/  # ElastiCache Valkey
│   └── msk/          # Amazon MSK (Kafka)
├── envs/
│   ├── dev/          # Root module do ambiente de desenvolvimento
│   └── prod/         # Root module do ambiente de produção
```

Cada diretório `envs/<env>/` é um root module independente. Os arquivos de composição crescem conforme os módulos são adicionados: `main.tofu`, `vpc.tofu`, `ec2.tofu`, `rds.tofu`, `elasticache.tofu`, `msk.tofu`, `data.tofu`, `local.tofu`, `variables.tofu`, `outputs.tofu`, `providers.tofu`.

### Fluxo de dados entre módulos

```
module.vpc.vpc_id             → module.ec2, module.rds, module.elasticache, module.msk (placement, SG)
module.vpc.public_subnet_ids  → module.ec2 (placement do bastion host)
module.vpc.private_subnet_ids → module.rds, module.elasticache, module.msk (placement privado)
module.vpc.vpc_cidr           → module.ec2, module.rds, module.elasticache, module.msk (regras CIDR do SG)
```

### Estado remoto

O estado é armazenado no S3. O backend é configurado em `providers.tofu`:
- Bucket: `algadelivery-tfstate`
- Key: `algadelivery/${var.environment}/remote.tfstate`

### Principais padrões de design

- O local **`common_tags`** propaga `Environment` e `ManagedBy = "OpenTofu"` para todos os recursos via `merge(var.common_tags, { Name = "..." })`
- **Dynamic blocks** para regras de ingress/egress de security group — as regras são passadas como variáveis `list(object({...}))` (introduzido em `04.02-utilizando-dynamic-blocks`)
- **For expressions e type constraints** introduzidos em `04.04-tipos-de-coleção-e-for-expressions`
- **`ngw_regional_mode`**: variável booleana traduzida para `"regional"` ou `"zonal"` nos locals, controlando o modo de disponibilidade do NAT Gateway
- **`lifecycle { prevent_destroy = true; ignore_changes = [ami] }`** nas instâncias EC2 a partir de `04.08-utilizando-o-lifecycle`
- **Key pairs SSH** são geradas em tempo de apply via `tls_private_key` + `aws_key_pair` + `local_sensitive_file` (`.pem` gravado em `path.root`, no gitignore)
- **Meu IP público** é obtido dinamicamente via `data.http.my_public_ip` e usado nas regras de SSH do bastion
- **Senhas seguras do RDS**: gerenciadas via `random_password` (introduzido em `04.11-gerenciando-senhas-com-segurança-no-rds`) — nunca commitadas; outputs sensíveis
- **Backup e janela de manutenção do RDS**: configurados via variáveis dedicadas do módulo a partir de `04.13-configurando-backup-e-manutencao-no-rds`

### Providers (Módulo 4 — atual)

| Provider | Versão | Uso |
|---|---|---|
| `hashicorp/aws` | `~> 6.0` | Todos os recursos AWS (VPC, EC2, RDS, ElastiCache, MSK, etc.) |
| `hashicorp/http` | `~> 3.0` | Obter o IP público do chamador |
| `hashicorp/tls` | `~> 4.0` | Gerar key pairs RSA |
| `hashicorp/local` | `~> 2.0` | Gravar arquivos `.pem` em disco |
| `hashicorp/random` | `~> 3.0` | Gerar senhas seguras do RDS |

### Providers planejados (Módulos 5+)

| Provider | Quando é introduzido | Uso |
|---|---|---|
| `hashicorp/kubernetes` | Módulo 6 (setup do EKS) | Recursos Kubernetes (namespaces, service accounts, etc.) |
| `hashicorp/helm` | Módulo 6 (AWS Load Balancer Controller em `6.10`; o Helm CLI é apresentado na `6.09`, com uma instalação de laboratório desinstalada no mesmo vídeo) → toda instalação Helm real do curso usa o provider | Todos os releases Helm provisionados via IaC, não via Helm CLI |
| `cloudflare/cloudflare` | Módulo 6 (`6.15`, DNS e HTTPS com OpenTofu) | Records de DNS: validação do ACM e o record que aponta o domínio para o ALB. **Exige um API token** — é a primeira variável realmente sensível do curso |

## Módulos planejados (ainda não registrados)

### Módulo 5 — Kubernetes: Fundamentos e Workloads (local com Kind)

**Todo o conteúdo de Kubernetes do curso, em 23 aulas, 100% local com Kind.** Resultado da fusão dos antigos Módulos 5 (Fundamentos e Workloads) e 6 (Rede, Escala e Segurança). O aluno sai daqui sabendo fazer deploy, expor e escalar uma aplicação real — sem nunca ter tocado na AWS.

O módulo tem quatro arcos:

**Arco 1 — Ponte conceitual e primitivos (`5.01–5.10`)**
- `5.01` Containers vs VMs: isolamento, portabilidade e trade-offs (as 3 antigas aulas de introdução — VMs, Containers, Containers-vs-VMs — fundidas em uma, já que Docker é pré-requisito do curso)
- `5.02` Introdução ao Kubernetes: o que é e por que existe (o modelo declarativo/control loop; a antiga aula de CNCF virou 1 slide aqui)
- `5.03` Arquitetura do K8s, Control Plane e Worker Nodes
- `5.04` Setup: kubectl + Kind + cluster local
- `5.05` Pods: ciclo de vida e criação — fases, `restartPolicy`, `kubectl describe/logs`
- `5.06` Pods multi-container: compartilhamento de network namespace e volumes
- `5.07` Namespaces, Labels, Selectors e Annotations — pré-requisito de `matchLabels` para tudo que vem depois
- `5.08` ReplicaSet: failover e disponibilidade de Pods — **fusão** da antiga aula-conceito de Failover com o ReplicaSet (ver princípio 1). Carrega a demo da dor, o argumento MTTR > MTBF e a disponibilidade em série (0,999⁵ ≈ 99,5%)
- `5.09` Deployments: gerenciando ReplicaSets e estratégias (Recreate e Rolling Update)
- `5.10` Revisões e rollback de Deployments — `rollout history/undo`, `revisionHistoryLimit`, `kubernetes.io/change-cause`, `pause/resume`, `progressDeadlineSeconds`

**Arco 2 — Configuração e storage (`5.11–5.15`)**
- `5.11` Volumes efêmeros: emptyDir, hostPath e Downward API — vem antes de ConfigMaps/Secrets para que a montagem como volume não deva explicação
- `5.12` ConfigMaps / `5.13` Secrets — `envFrom`, `env.valueFrom`, montagem como volume, `immutable`, e a exceção do `subPath` na propagação
- `5.14` Persistent Volumes, PVC e Storage Classes — o contrato "PVC é o pedido, PV é o recurso, StorageClass é o fabricante"; no Kind o provisioner é o `local-path` (StorageClass default `standard`)
- `5.15` StatefulSets: identidade estável, ordenação e `volumeClaimTemplates` (depende do PVC de `5.14`). Fecha com o contraste "failover de dados é RDS Multi-AZ, não K8s" — paga a dívida conceitual do Módulo 4

**Arco 3 — Rede, resiliência e a aplicação real (`5.16–5.21`)**
- `5.16` Services: ClusterIP e descoberta de serviço — o problema do IP efêmero, Endpoints/EndpointSlice, DNS interno (`<svc>.<ns>.svc.cluster.local`). Resolve só o tráfego **interno**
- `5.17` Services: **NodePort e Headless** — a aula foi desmembrada da `5.16` (que ficava grande demais) e fecha a família de tipos de Service: acesso externo sem `port-forward` (NodePort, com citação de LoadBalancer) e o caso de bancos com identidade (Headless), fechando o loop aberto pelo `serviceName` do StatefulSet em `5.15` — agora com o **mesmo PostgreSQL da `5.15`** como exemplo, em vez do app de brinquedo
- `5.18` Self Healing com Readiness, Liveness e Startup Probes (conceito + mecanismo fundidos). Readiness tira o Pod do Endpoints — callback forte a `5.16`–`5.17`
- `5.19` Resource Requests, Limits e QoS Classes — CPU faz throttling, memória mata (OOMKilled/137); Guaranteed, Burstable, BestEffort e a ordem de eviction
- `5.20` Ingress: **Traefik v3** com path-based e host-based routing — o limite L4 do Service e por que existe L7. Só local, com Kind (`extraPortMappings` 30080→80 / 30443→443 + Service NodePort fixo). O `rewrite-target` vira CRD `Middleware`, e é daí que sai o contraste que sustenta a aula: **Ingress sem anotação é padrão e viaja para o ALB; anotação e CRD são proprietários e se jogam fora**. Na AWS o ingress é o ALB (Módulo 6). **Aula objetiva (~16–18 min, 5 blocos, 5 diagramas)** — cortada em duas rodadas pelo instrutor até virar "dois conceitos + hands-on". A estrutura final é: **limitação do Service → Ingress → Ingress Controller → hands-on**. Saíram: dashboard do Traefik, o `Middleware`/reescrita de caminho **inteiro**, `defaultBackend`, precedência de regras, `pathType` além do `Prefix`, TLS, a anatomia do objeto em diagrama próprio e o bloco "padrão × proprietário" (virou um parágrafo de fechamento de 1 min, com o YAML na tela). Usa o `hellojava` em dois Deployments (`hello` e `rastreio`, mesma imagem — o campo `pod` da resposta distingue quem atendeu).
  - **Ordem do hands-on: host ANTES de path** (decisão do instrutor). Roteamento por host é "um DNS por serviço", que é como aplicação real é publicada, **e é o caso sem pegadinha** — com `path: /` não há prefixo envolvido. Path entra depois como a alternativa de domínio único, e é aí que se comenta em voz alta que **o prefixo chega intacto na aplicação**.
  - **O app ganhou uma linha na `5.20`:** `hellojava:v7` responde em `/`, `/hello` e `/rastreio` (`@GetMapping({"/", "/hello", "/rastreio"})`). Isso é o que permite ensinar path-based com Ingress **100% padrão da API**, sem reescrita de caminho — que não é padrão e varia por controller. Cortar o `Middleware` da aula depende dessa linha.
  - **⚠️ Exceção deliberada à regra do Helm: esta aula NÃO usa Helm.** O Traefik é instalado com `kubectl apply --server-side -f traefik/traefik-41.4.0.yaml` — o chart oficial **renderizado** com `helm template` (valores versionados em `traefik/values.yaml`), gerado na preparação e commitado na pasta da aula. O motivo é de ordem curricular: **Helm só é apresentado depois da `5.20`** — tem aula própria na `6.09` e é aprofundado no Módulo 7 (`7.03–7.05`) —, e um `helm install` na `5.20` obrigaria a explicar a ferramenta fora de hora. A aula usa isso como loop proposital ("de onde vem esse YAML"), **pago na `6.09`**. O `--server-side` é obrigatório: os 25 CRDs do Traefik estouram o limite da anotação do apply tradicional. **Não confundir com a regra dos Módulos 6+**, onde toda instalação Helm real usa o `helm_release` do OpenTofu.
- `5.21` **Setup do AlgaDelivery em k8s (api + db)** — aula de integração, o ponto de virada do módulo (ver princípio 9): Deployment para a API, StatefulSet + PVC para o Postgres, ConfigMap + Secret para config/credenciais, Services para a comunicação interna — e, pela primeira vez, **probes, `resources` e Ingress já nascem no manifesto**, em vez de serem retrofitados depois. A API é publicada por **Ingress** (`path: /api`, sem anotação — o caminho da regra coincide com o caminho real da API, então não precisa de `Middleware`), não mais por NodePort
  - **Por que Traefik e não ingress-nginx:** o ingress-nginx foi anunciado como aposentado em 11/11/2025 e efetivamente aposentado em março/2026 (última release `controller-v1.15.1` em 19/03/2026, repo arquivado em 23/03/2026). O curso mantém o bloco histórico explicando isso, mas **não grava em cima de projeto morto**. Traefik foi escolhido em vez de Gateway API porque precisa ensinar o **recurso `Ingress`** — é o que o aluno vai escrever no Módulo 6 com `ingressClassName: alb`

> **Reorder Probes/Resources → Setup (decisão do instrutor):** originalmente Probes (`5.20`) e Resources (`5.21`) vinham **depois** da Setup do AlgaDelivery, cada uma fechando com um bloco de callback que "retrofitava" o conceito no Deployment real. O instrutor decidiu inverter: ensinar as duas no `hellojava` **antes** da Setup, para que a Setup monte o manifesto de produção **já com probes e `resources` desde a primeira versão**, sem remendo.
>
> **Reorder Ingress ↔ Setup (decisão do instrutor, rodada seguinte):** o Ingress também passou para **antes** da Setup — hoje é `5.20`, com a Setup em `5.21`. Mesma lógica das probes: a Setup passa a compor o Ingress **desde o primeiro `kubectl apply`**, em vez de o Ingress ser aplicado depois em cima de um setup já montado. Três efeitos colaterais bons: (1) a aula de Ingress volta a usar o `hellojava` (app de brinquedo, foco no primitivo) em vez da aplicação real; (2) a recriação do cluster Kind (`30080→80`, `30443→443`, `ingress-ready`) acontece com o cluster **vazio**, eliminando o passo "reaplique todo o AlgaDelivery" que a ordem antiga exigia; (3) a Setup deixa de expor a API por NodePort e passa a expô-la por Ingress, o que é a forma correta e a que o Módulo 6 repete com o ALB.

**Arco 4 — Operar sob carga e consolidar (`5.22–5.23`)**
- `5.22` **HPA: autoscaling de Pods** (título encurtado — o Metrics Server saiu do título, não do conteúdo) — a % do HPA é sobre o **request**, então `5.19` é pré-requisito duro
- `5.23` **Desafio: Realize a configuração dos manifestos do Courier Management** — fecha o módulo. O aluno replica a `5.21` + `5.22` para o **segundo** microsserviço do AlgaDelivery e, com isso, fecha as duas pontas que a `5.21` deixou explicitamente abertas: o tópico `deliveries.v1.events` ganha consumidor, e o `POST /api/v1/deliveries` (que devolvia 502) volta a funcionar. O AlgaDelivery deixa de ser *um* serviço em Kubernetes e passa a ser **um sistema de microsserviços** em Kubernetes.
  - **Três artefatos, não um roteiro:** enunciado HTML para a plataforma em `desafio-05.23-descricao.html` (raiz do repo, mesmo padrão dos desafios do Nível 9), solução comentada no `README.md` da pasta da aula, e os manifestos em `courier-management/k8s/`. Validado de ponta a ponta no cluster.
  - **As quatro diferenças que fazem o desafio não ser copiar-e-colar:** a porta é **8081** (aparece em 4 lugares); o Ingress **não pode** reusar `metadata.name: algadelivery` (apagaria a regra do `delivery-tracking`, e o `apply` diz `configured` sem avisar); o banco `courierdb` **não existe** (e o `/docker-entrypoint-initdb.d` **não** resolve, porque o PVC já foi formatado na `5.21`); e o Deployment nasce **sem `replicas`**, cumprindo o checklist da `5.22`.
  - **Dois achados medidos no cluster que valem conteúdo:** (1) o tópico tem **3 partições** e duas réplicas do consumidor as **dividem** — logo `maxReplicas` acima de 3 dá Pods com zero partição, o que materializa a armadilha "escalar o que não tem por quê" da `5.22`; (2) subir o Service com o nome e a porta certos **não conserta** o caminho HTTP entre os serviços, porque o `RestClient` do `delivery-tracking` é `@LoadBalanced` e trata `courier-management` como **serviceId de registry**, não como nome DNS (erro exato: `IllegalArgumentException: Service Instance cannot be null`). A lição: **em Kubernetes o Service já é o registry**, e o Eureka ligado *intercepta* e quebra a resolução. A saída sem tocar no código é registrar a instância no `SimpleDiscoveryClient` via `JAVA_OPTS`; a saída correta é tirar o `@LoadBalanced`, e isso é conversa do Módulo 9.

> **Jobs/CronJobs, Lens e Rancher removidos da ementa (decisão do instrutor):** as três aulas saíram, e o módulo passou a terminar no desafio `5.23`. O roteiro de Jobs e CronJobs já estava escrito e foi **preservado sem número** em `roteiros/modulo-05/roteiro-jobs-e-cronjobs.md` (a faixa dele no Excalidraw também continua desenhada) — se a aula voltar, é de lá que se recupera. Consequência a registrar: as fases `Succeeded`/`Failed` do Pod, apresentadas na `5.05`, voltaram a ficar **sem dono** no módulo, e o catálogo de workloads fecha sem o controller "do que termina".

> **Grafana k6 removido (decisão do instrutor):** as duas aulas de teste de carga com k6 (a antiga ferramenta e a aplicação ao cluster) foram **cortadas** da ementa. O princípio "ferramenta → aplicação da ferramenta" que elas ilustravam não tem mais exemplo no módulo. A validação empírica de HPA/self-healing sob carga medida deixou de ser conteúdo do curso; a `5.22` (HPA) fecha com uma demo de carga simples e artesanal, sem instrumento de medição dedicado.

### Módulo 6 — Provisionando o cluster EKS na AWS com OpenTofu

**16 aulas.** Provisionamento de infra puro antes de qualquer deploy de aplicação. Cada componente gerenciado segue o padrão **Console → OpenTofu**.

**As duas aulas conceituais de abertura** (`6.01` EKS e `6.02` IAM) são a teoria de base do módulo; o `tofu apply` começa na `6.04`. Antes do controller entra mais uma aula com bloco conceitual — a `6.09` (Helm), que não cria recurso com OpenTofu —, e a própria aula do controller (`6.10`) abre com um bloco rápido de **Load Balancer**.

- **`6.02 IAM essencial: policies, roles e o modelo de confiança` — aula nova, e paga uma dívida real.** Não há **um único** recurso `aws_iam_*` nos Módulos 3 e 4, e IAM não aparece na ementa dos Módulos 1–5 — deu para viver assim porque nada do que foi provisionado precisava **agir em nome do usuário**. O EKS quebra isso no primeiro campo do primeiro formulário. Escopo: identidade × permissão, policy (identity-based × resource-based; managed × customer-managed × inline), anatomia do JSON, **trust policy e principal** (Service / AWS / Federated), STS. **IRSA não entra** (é a `6.10`). Isso mantém a lacuna registrada em "Lacunas conhecidas" — continua sem módulo dedicado de IAM —, mas transforma o "pontualmente" numa base explícita, e os Módulos 8 e 10 herdam pronto (o 10 precisa de **resource-based policy** para a bucket policy do OAC do CloudFront)
- **IAM × RBAC abre a `6.03`, não a `6.01`.** O bloco "IAM autentica, RBAC autoriza" ficava na aula conceitual de EKS e **pressupunha a aula de IAM, que vem depois dele**; além disso ensinava em slide o que a `6.03` demonstra na tela — `update-kubeconfig`, access entries, `authentication_mode` (que são **campos do formulário**) e o erro `Unauthorized`. Foi movido para a abertura da `6.03`. Na `6.01` ficou **uma frase** nomeando os dois sistemas. É também onde a **dívida DV-01** (ServiceAccount/RBAC, cortada na fusão M5+M6) é paga no nível de **pessoa**; o nível de **Pod** fica na `6.10`, em ~1 min
- **Sem node autoscaling** — Cluster Autoscaler / Karpenter foram intencionalmente cortados. O curso ensina autoscaling em nível de pod (HPA) no Módulo 5 (`5.22`) mas NÃO cobre autoscaling em nível de node
- **Node groups (`6.05`/`6.06`):** `dev` = 1 node On-Demand + um node group **Spot** (é onde `capacity_type` é ensinado); `prod` = 1 × `t3.medium` On-Demand. A `6.06` ensina também **`cordon`/`drain` e PodDisruptionBudget** inline (dívidas DV-02 e DV-05), com a demo de `drain` **antes** do PDB — a dor antes do remédio. **Taints, tolerations e node affinity NÃO entram aqui**: continuam estreando na `11.03`
- **Core EKS add-ons** (VPC CNI, CoreDNS, kube-proxy) já vêm pré-instalados com o cluster. As duas aulas de add-ons (`6.07` Console, `6.08` OpenTofu) cobrem promovê-los para EKS-managed add-ons **e ensinam o EBS CSI Driver nas mesmas aulas** — o CSI Driver é ele mesmo um EKS add-on (NÃO default; necessário para o PersistentVolume do Elasticsearch stateful no Módulo 11), então é incorporado em vez de ganhar seu próprio par Console/OpenTofu. A `6.07` também define **DaemonSet** em uma frase (dívida DV-04), porque `kubectl get ds -n kube-system` é o comando que prova a instalação. **O OIDC provider do cluster nasce aqui, não na `6.04`** (ensino gradual — decisão `D-14` do `roteiros/modulo-06/PLANO-MODULO-06.md`): clicado no Console na `6.07` (IAM → Identity providers) e escrito em código na `6.08` (`modules/eks/main.tofu`), porque o **primeiro consumidor** é a role IRSA do EBS CSI; o AWS Load Balancer Controller (`6.10`) é o segundo. **A `6.04` também não tem `access_entries`:** com `bootstrap_cluster_creator_admin_permissions = true` a AWS cria sozinha o access entry de admin de quem roda o `apply` (implícito, fora do código e do state); outra identidade precisaria de access entry feito no Console, como na `6.03`.
- **Helm TEM aula própria: `6.09 Helm essencial: chart, values e release`** (~20–24 min, prática de terminal **sem OpenTofu**) — **decisão do instrutor, que reverte** a escolha anterior (Helm como bloco de abertura de ~5 min dentro da aula do controller, aceita na revisão externa). Escopo: o que é Helm (gerenciador de pacotes do Kubernetes; *pacote → chart*, *instalação → release*); **instalar o CLI** (`brew install helm`); ler **o chart real `aws-load-balancer-controller` `3.5.0`** que a `6.10` instala (`helm show values`, `helm template` — o chart se recusa a renderizar sem `clusterName`); e **o Postgres da `5.21` empacotado como chart próprio** (`06.09-helm-essencial-chart-values-e-release/postgres/`, com `{{ .Release.Name }}` nos nomes e `storage.className: gp3` como padrão), num ciclo `lint` → `install` → `psql` → `upgrade --set replicaCount=2` → `history` → `uninstall` → **apagar os PVCs**, que o `uninstall` não apaga. Paga o loop da `5.20` ("de onde veio esse YAML"). **Tem pasta, mas não é pasta OpenTofu**: `06.09-…/` traz um `README.md` de comandos, o chart e um `values-override.yaml`. O motivo de precisar de Helm no módulo continua o mesmo: o **AWS Load Balancer Controller não é um EKS managed add-on** (`aws/containers-roadmap#1162`, aberta desde 2020), e como o Rancher virou EC2+Docker, a `6.10` é a única aula do módulo que instala algo de verdade com Helm
  - **⚠️ Exceção deliberada à regra do Helm: esta aula roda `helm install` com o CLI.** A release (`meu-postgres`, namespace `helm-lab`) é **de laboratório**: nasce, muda para a revisão 2 e é **desinstalada no mesmo vídeo**, junto com os PVCs. O motivo é didático: o aluno precisa ver o ciclo de vida de uma release com os próprios olhos antes de a `6.10` esconder esse ciclo atrás do `helm_release`. A aula diz isso em voz alta e fecha com o loop "na `6.10` quem aperta o botão é o `helm_release`". **Não confundir com a regra dos Módulos 6+**, onde toda instalação Helm real usa o `helm_release` do OpenTofu — mesmo tipo de exceção da `5.20`, que usou `helm template` sem Helm na aula
  - ⚠️ **Sobreposição com o Módulo 7 — questão aberta, decisão do instrutor, e ela cresceu:** com o CLI, o ciclo de release e o chart próprio, a `6.09` toca a `7.03`, a `7.04`, a `7.05`, a `7.06` e a `7.08` (tabela no `roteiros/modulo-06/PLANO-MODULO-06.md`, §1.5). A ementa do Módulo 7 **não** foi alterada
- **Load Balancer e Target Groups são um bloco rápido DENTRO da aula do controller (`6.10`)**, ~5–6 min, **antes** da instalação e **sem demo no Console** — **decisão do instrutor**, que desfez uma aula exclusiva criada logo antes. Nenhuma aula anterior cobria listener, regra, target group ou health check. Escopo: o que é um Load Balancer, com **uma analogia só — a recepção de um prédio** (um endereço na porta; a recepcionista indica o caminho = a **regra**; o andar certo = o **target group**; nunca para uma sala fechada = o **health check**); a cadeia **listener → regra → target group → targets**; ALB (L7) × NLB (L4) em uma frase; e **`target-type: instance` (via NodePort) × `ip` (direto no Pod, graças ao VPC CNI)** — o controller usa `ip`. O bloco fecha com a ponte *"quem monta tudo isso, a partir de um `Ingress`, é o controller que você vai instalar agora"*. A aula exclusiva, **com a demo no Console** (ALB e target group montados à mão apontando para IPs de Pods, e apagados no fim), foi **preservada sem número** em `roteiros/modulo-06/roteiro-load-balancer-e-target-groups-demo-console.md` — se a demo voltar, é de lá que se recupera
- **AWS Load Balancer Controller** (via Helm provider, precisa de IRSA/IAM) → **ALB Ingress** para roteamento L7 por path/host (`6.10–6.11`). Stack de ingress nativa da AWS; **substitui o antigo NGINX Controller + NLB + Kong**. O ingress local é ensinado **apenas no Módulo 5** (`5.20`, Traefik v3 no Kind) — a narrativa é "aprender o recurso `Ingress` localmente → trocar só o `ingressClassName` e as anotações na AWS"
- **Registrar o domínio tem aula própria: `6.12 Registrando um domínio no Registro.br`** (~8–10 min, só Console, sem OpenTofu e sem pasta) — **decisão do instrutor (`D-15` do `roteiros/modulo-06/PLANO-MODULO-06.md`)**, porque as aulas de DNS e HTTPS pressupunham um domínio que nenhuma aula criava. Escopo: criar conta (exige **CPF ou CNPJ**), pesquisar e registrar o `.com.br`, pagar (**boleto demora** — comprar antes), *registrador × quem responde o DNS* (o Registro.br guarda a posse e, por padrão, também hospeda o DNS; a Cloudflare passa a responder na `6.13`), mostrar **sem mexer** a tela de servidores DNS e **conferir o DNSSEC** (se ativo, quebra a troca de NS). Passos do painel, preço (~R$ 40/ano) e prazos **não testados** — conferir na preparação. A inclusão dessa aula empurrou as antigas `6.12`–`6.15` para `6.13`–`6.16`
- **Cloudflare: conta, conceitos e nameservers numa aula só (`6.13`)** — eram duas aulas (22–27 min somados) para criar conta e apontar NS, na mesma ferramenta, sem dependência entre si além da ordem. O peso didático vai para o **mecanismo**: o que é um nameserver, por que trocar os NS transfere a autoridade da zona, propagação e verificação
- **DNS (record do ALB) + ACM + HTTPS juntos**, separados em Console → OpenTofu: o fluxo TLS completo feito no **Console** (`6.14`) e recriado como **OpenTofu** (`6.15`). Fundido em uma aula cada porque a validação DNS do ACM, o record do ALB e o binding do cert ao Ingress são um único fluxo contínuo. O **conceito de ACM é ensinado inline** no início de `6.14`
- **Domínio do laboratório: `algashop.com.br`** — e **não** o `algadelivery.com.br` prometido nos ganchos da `5.20`. Decisão do instrutor: **manter os dois**; a `6.14` reconhece a diferença em **uma frase** e segue (a `6.12` também diz que o aluno usa o domínio dele). Os roteiros do Módulo 5 não são ajustados. O nome é acessório; o assunto é o mecanismo de DNS
- **Rancher (`6.16`) roda numa EC2 dedicada com Docker**, não no cluster — reusa o `modules/ec2` do Módulo 4 (há um `module "rancher"` já comentado no fim de `envs/dev/ec2.tofu` do `04.20`). Sem Helm, sem workload no cluster

**Decisões de código do módulo:**
- **Root module único, sem `envs/`** — os `.tofu` ficam **direto na raiz da pasta da aula**, junto de `modules/` (`source = "./modules/..."`), `k8s/` e `user-data/` (`6.16`), e o ambiente é escolhido por **`-var-file=dev.tfvars` / `-var-file=prod.tfvars`**. Decisão do instrutor (`D-13` do `roteiros/modulo-06/PLANO-MODULO-06.md`): no Módulo 6 o código de dev e prod era idêntico, só os **valores** diferiam. **Regra de bolso:** pasta por ambiente quando o *código* difere; tfvars quando só os *valores* diferem. As variáveis que diferem entre ambientes (VPC/subnets, RDS, ElastiCache, `eks_endpoint_public_access`, `eks_enabled_cluster_log_types`, `eks_node_groups` a partir da `6.06` etc.) ficam **sem `default`** em `variables.tofu` — esquecer o `-var-file` dá `No value for required variable` (falha alta). `dev.tfvars` e `prod.tfvars` **ficam fora do Git** (decisão do instrutor, revertendo a anterior: o `dev.tfvars` chegou a carregar o token da Cloudflare); o que vai para o Git é o **`example.tfvars`** de cada pasta, gerado do `dev.tfvars` com o token removido e o `cloudflare_zone_id` como placeholder — o aluno roda `cp example.tfvars dev.tfvars` e ajusta. Segredo (token da Cloudflare `6.15`, `rancher_bootstrap_password` `6.16`) fica só em `TF_VAR_*`. O backend continua com `key = "algadelivery/${var.environment}/remote.tfstate"`, e trocar de ambiente exige `tofu init -reconfigure -var-file=<outro>.tfvars`. Única mudança de lógica: nome do bastion e keypair viram `"${var.environment}-bastion"` / `"${var.environment}-${var.keypair_name}"` (em dev, `development-bastion`). Providers `kubernetes`/`helm` configurados a partir de `data.aws_eks_cluster` + `data.aws_eks_cluster_auth` chaveados por um **`local.cluster_name` estático** (montado só de variáveis, nunca `module.eks[0].cluster_name`) — é o que torna a config do provider resolvível em plan time
- **Flags `enable_*` com `count`** em vez de comentar bloco: `enable_rds`, `enable_elasticache` e `enable_msk` ficam em `false` no Módulo 6 (controle de custo virando código). Com `count`, os outputs viram `one(module.X[*].y)`
- **`required_version = ">= 1.8"`** — o `backend "s3"` interpola `${var.environment}` na `key`, o que depende da **early variable evaluation** do OpenTofu 1.8. Funciona no OpenTofu e **não** no Terraform: é um ponto de divergência que vale 40 s de aula na `6.04`
- **Primeiro `sensitive = true` do curso** (`cluster_certificate_authority_data`, e o token da Cloudflare na `6.15`) e **primeiro `depends_on` de verdade** (no `aws_eks_cluster`, e existe por causa do **`destroy`**: sem ele a EKS perde a permissão de limpar as próprias ENIs e o cluster trava em `DELETING`)
- **Endpoint do cluster:** público **restrito ao IP do instrutor** (reusa o `data.http.my_public_ip` do Módulo 3) + privado. Em `prod.tfvars`, público desligado

**Sem API Gateway:** o curso usa intencionalmente **ALB Ingress puro (roteamento + TLS apenas)**, não um API gateway. O Kong foi totalmente removido. Auth/rate-limiting NÃO são tratados na borda — ficam no nível da aplicação (Spring). Se esses recursos de borda forem necessários um dia, o caminho ALB-native é AWS WAF + OIDC/Cognito (fora do escopo).

> ⚠️ **O ALB é criado pelo controller dentro do cluster, não pelo OpenTofu** — ele **não está no state** e **sobrevive ao `tofu destroy`**, cobrando por hora. O ritual é sempre `kubectl delete ingress --all -A` → esperar o ALB sumir → `tofu destroy -var-file=dev.tfvars`. Ensinado na `6.01`, plantado na `6.04`, repetido na `6.11`.

### Módulo 7 — Ferramentas de Deploy e GitOps

16 aulas. **O Kustomize foi totalmente removido** (as 3 aulas de Kustomize foram excluídas) — o Helm cobre tanto templating quanto config multi-ambiente via `values`, então o Kustomize era redundante. O módulo flui de desafios de gerenciamento de manifestos (`7.02`) → Helm (`7.03–7.08`) → GitOps/ArgoCD (`7.09–7.16`), terminando em `7.16 Continuous Deployment na prática com GitLab e ArgoCD`. (O antigo bloco de Kong/API-Gateway foi removido antes, quando a stack de ingress migrou para ALB — o roteamento agora vive no ALB Ingress, Módulo 6 / Módulo 9. O Argo Rollouts também foi removido.)

**Regra crítica:** `7.03–7.05` ensinam o Helm CLI conceitualmente (anatomia do chart, `helm install/upgrade/rollback`), mas **toda instalação Helm real do curso usa o Helm provider do OpenTofu, não o CLI** (a única exceção é a instalação **de laboratório** da `6.09`, desinstalada no mesmo vídeo) — ex.: AWS Load Balancer Controller (`6.10`), ArgoCD (`7.11 Instalando ArgoCD via Helm provider no OpenTofu`) e, no Módulo 11, o kube-prometheus-stack (`11.05`) e o operator ECK (`11.11`).

### Módulo 9 — Deploy do backend do AlgaDelivery (usa a infra preparada no Módulo 6)

Módulo enxuto (6 aulas). Foca puramente em USAR o que já foi ensinado/provisionado — NÃO reensina nem reprovisiona nada. Cortado de 10 → 6 aulas removendo tudo que já foi coberto em outro lugar:
- **ALB Ingress** — o mecanismo foi ensinado no Módulo 6 (`6.10–6.11`); aqui é apenas mais um manifesto templatizado **dentro do Helm Chart do AlgaDelivery** (`9.02`), NÃO uma aula standalone
- **Externalização de config (Parameter Store)** — totalmente ensinada no Módulo 8 (`8.03–8.08`, incl. Spring Cloud AWS); os paths específicos do AlgaDelivery são conectados nos `values` do Helm (`9.03`), NÃO reensinados
- **O ArgoCD NÃO é instalado aqui** — foi instalado uma vez no Módulo 7 (`7.11`, via Helm provider do OpenTofu no EKS). O Módulo 9 apenas registra a **Application** do AlgaDelivery (`9.04`). A antiga `9.07 Instalando ArgoCD` era uma duplicata literal de `7.11` e foi removida
- O que resta é genuinamente novo: Helm Charts da aplicação (`9.02`, incl. Ingress), values multi-ambiente (`9.03`), ArgoCD Application (`9.04`), a pipeline GitOps completa (`9.05`), teste em produção (`9.06` — a "Conclusão e próximos passos" do curso inteiro fica ao final do Módulo 11)

### Módulo 10 — Deploy do Frontend do AlgaDelivery (S3 + CloudFront)

Módulo dedicado ao frontend (6 aulas). A SPA é **estática** — hospedada em S3 + CloudFront, **não** no cluster. Vem depois do Módulo 9 porque consome a API já exposta pelo ALB Ingress (`9.02`). Abre com uma **introdução ao projeto** (`10.01`: rodar o frontend localmente, visão geral da pipeline, o que vai ser feito deploy) e um **deploy completo de S3 privado + CloudFront + OAC no Console** (`10.02`) — o setup seguro adequado, não descartável — para uma vitória rápida. O par **Console → OpenTofu** é simétrico: `10.02` faz no Console, `10.03` recria a mesma stack (S3 privado + CloudFront + OAC) como código em **uma aula** (conceitos de CDN/cache/OAC explicados inline — sem aula de conceitos standalone, já que `10.02` já demonstrou; e a bucket policy do OAC fecha na mesma aula porque o ARN da distribution existe lá). Contrasta deliberadamente com o deploy do backend: **CI push-based** (GitLab → `s3 sync` → invalidação do CloudFront), NÃO GitOps/ArgoCD. A stack fica neste módulo (não separada no Módulo 6) já que a config do CloudFront é fortemente acoplada à app frontend.
- `10.03` **Criando S3 privado + CloudFront com OAC com OpenTofu** — bucket privado (public-access-block + `BucketOwnerEnforced`) + distribution CloudFront + OAC + bucket policy, tudo em um
- **Cert ACM em `us-east-1`** (`10.04`, obrigatório para CloudFront independente da região da infra — contraste com o ACM regional para Ingress no Módulo 6) + domínio customizado via Cloudflare DNS
- `10.05` **Routing de SPA** (custom error responses 403/404 do CloudFront → `index.html`) + API base URL do frontend apontando para o ALB Ingress + CORS
- `10.06` Pipeline GitLab CI: build → `s3 sync` → invalidação do CloudFront; cache busting / versionamento de assets + teste em prod
- Termina em `10.06` (frontend no ar); a "Conclusão e próximos passos" do curso inteiro fecha o Módulo 11

### Módulo 11 — Observabilidade em Produção: Prometheus, Grafana e Elastic APM

Último módulo de ensino antes do apêndice (19 aulas). Observa o AlgaDelivery totalmente implantado (backend M10 + frontend M11) em produção. **Dois sistemas complementares, NÃO redundantes** — essa distinção precisa ser ensinada explicitamente:
- **Métricas (pull)**: o Prometheus faz scraping de cpu/mem/rede via container/cluster/host através de exporters + Alertmanager → dashboards no Grafana. Instalado via `kube-prometheus-stack` (Helm provider / OpenTofu).
- **APM (push)**: Elastic APM Java agent no serviço `invoice` → APM Server (processa, indexa, ILM) → Elasticsearch (armazenamento) → Kibana (UI de APM).

Decisões de design principais (do instrutor):
- O escopo é **métricas + APM apenas** (sem logging centralizado / Filebeat) — fiel ao diagrama de referência.
- Elastic Stack instalado via **operator ECK** (Elastic Cloud on Kubernetes) em `11.11` (conceito + CRDs + install fundidos), ele mesmo um `helm_release` no OpenTofu; ES/Kibana/APM Server gerenciados como CRDs.
- **Elasticsearch single-node** (simplicidade didática, lab mais barato) com PersistentVolume via EBS CSI Driver.

Callbacks fortes que fecham o arco Conceito→Implementação do curso:
- **Node group dedicado `node-tooling`** (EKS managed node group, Módulo 6) isolado com **taints/tolerations + node affinity**. ⚠️ **Atenção após a fusão M5+M6:** taints/tolerations e affinity **deixaram de ser ensinados** (eram o antigo `6.10–6.12`). Esta aula (`11.03`) passou a ser a **primeira** apresentação desses conceitos e precisa ensiná-los inline, não apenas fazer callback.
- O Elasticsearch é **stateful** → PersistentVolumes/StorageClass (`5.14`, Módulo 5) + EBS CSI Driver (Módulo 6).
- Todas as instalações via **Helm provider no OpenTofu** (regra do curso a partir de `7.11`).
- O Java agent é conectado nos values do Helm Chart do `invoice` (Módulo 9).
- Fecha com `11.19 Conclusão e próximos passos` (todo o sistema observado em produção).

## Trabalhando com este repositório

### Ao criar um novo diretório de aula

1. Confirme o número e o título da aula contra `.EMENTA-NIVEL-11-AWS.md`
2. Copie a estrutura da aula adjacente anterior (as aulas são snapshots incrementais)
3. Aplique APENAS o diff descrito pelo título da aula — não refatore arquivos não relacionados
4. Use a convenção de nomenclatura `<MM>.<NN>-<titulo-em-kebab-case>/`

### Ao trabalhar com código dos Módulos 5+ (planejados)

- O Módulo 5 já tem diretórios de `05.04` a `05.11`; os demais ainda não existem. Se for pedido para fazer o scaffold, siga o padrão existente (snapshots incrementais, um dir por aula).
- Os **roteiros de aula** do Módulo 5 ficam em `roteiros/modulo-05/roteiro-<M>.<NN>.md` — leia os vizinhos antes de escrever um novo, o estilo é padronizado.
- Para releases Helm nos Módulos 6/7/9, use por padrão recursos `helm_release` via OpenTofu, NÃO comandos shell `helm install`.

### Ao atualizar a ementa

O arquivo da ementa (`.EMENTA-NIVEL-11-AWS.md`) rastreia os badges de status dos módulos:
- 🎥 _em gravação_ — Módulo 5 atualmente
- ✅ _finalizado_ — Módulos 1, 2, 3, 4
- 📋 _ementa planejada_ — Módulos 6–11
- 🔜 _a planejar_ — Módulo 12 (Apêndice; ementa ainda não definida)

Renumerar módulos é frágil porque os números de aula `M.NN` se repetem entre módulos. Edite os módulos em ordem reversa (do maior para o menor) para evitar colisões.

## Regras do .gitignore

Os itens a seguir são excluídos e nunca devem ser commitados:
- `.terraform/`, `.terraform.lock.hcl`
- `*.tfstate`, `*.tfstate.backup`
- `*.tfvars`, `*.tfvars.json` — inclusive `dev.tfvars` e `prod.tfvars` do Módulo 6. Os modelos versionados são `*.example.tfvars` e, no Módulo 6, o `example.tfvars` de cada pasta (sem segredo; segredo vai por `TF_VAR_*`)
- `*.pem` (chaves privadas SSH geradas)
- `*.tfplan`, `*.plan`
