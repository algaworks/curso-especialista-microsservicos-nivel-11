# Plano: Criar código Terraform para Módulo 04

## Contexto

O Módulo 3 tem 20 aulas já gravadas (03.03 a 03.20). A aula 03.20 (testando conectividade) é a base de código final. Agora criamos o Módulo 04, evoluindo incrementalmente a partir de 03.20.

Decisões:
- Sem aula dedicada de `terraform_remote_state` — root module único com sub-módulos
- Sem aulas de "Introdução" separadas — conceito + provisionamento na mesma aula
- Console + OpenTofu mantidos para RDS (2 aulas); ElastiCache e MSK condensados (1 aula cada)
- Teste de conexão ao RDS incluído nas aulas de Console e OpenTofu (sem aula separada)

## Estrutura de diretórios

```
04-modulos-e-servicos-gerenciados/
├── 04.01-utilizando-dynamic-blocks/
├── 04.02-criando-modulo-vpc/
├── 04.03-criando-modulo-ec2-e-inputs/
├── 04.04-multi-env/
├── 04.05-workspaces/
├── 04.06-dados-sensiveis/
├── 04.07-lifecycle-e-boas-praticas/
├── 04.08-projeto-infra-algadelivery-modularizada/
├── 04.09-revisitando-desenho-infra-e-custos/
├── 04.10-entendendo-e-provisionando-rds-via-console/
├── 04.11-provisionando-rds-via-opentofu/
├── 04.12-entendendo-e-provisionando-elasticache-valkey/
├── 04.13-entendendo-e-provisionando-msk-kafka/
└── 04.14-testando-conectividade-todos-servicos/
```

**Total:** 14 aulas (04.01–04.14). Teste de RDS é feito dentro das aulas 04.10 (Console) e 04.11 (OpenTofu).

---

## Detalhamento por aula

### PARTE 1 — Módulos, Multi-ambiente e Práticas Avançadas (8 aulas)

---

### 04.01 — Utilizando Dynamic Blocks
**Delta vs 03.20:** Refatora `security_group.tofu` para usar `dynamic` blocks.

**Arquivos modificados:**
- `variables.tofu` — adiciona variáveis de regras de SG como lista de objetos
- `security_group.tofu` — ingress/egress viram `dynamic` blocks iterando sobre as variáveis
- Demais arquivos: cópia idêntica de 03.20

---

### 04.02 — Criando Módulo VPC
**Delta vs 04.01:** Extrai toda a rede para `modules/vpc/`.

**Estrutura:**
```
04.02-criando-modulo-vpc/
├── modules/
│   └── vpc/
│       ├── main.tofu          ← VPC, subnets, IGW, NAT, route tables
│       ├── variables.tofu     ← vpc_cidr, subnet configs, ngw_regional_mode
│       └── outputs.tofu       ← vpc_id, subnet_ids, igw_id, ngw_id, rt_ids
├── main.tofu                  ← module "vpc" { source = "./modules/vpc" }
├── security_group.tofu        ← fica na raiz, referencia module.vpc.vpc_id
├── ec2.tofu                   ← fica na raiz, referencia module.vpc.outputs
├── data.tofu
├── local.tofu
├── variables.tofu
├── outputs.tofu
└── providers.tofu
```

---

### 04.03 — Criando Módulo EC2 + Inputs
**Delta vs 04.02:** Extrai EC2 + SG para `modules/ec2/`.

**Estrutura:**
```
04.03-criando-modulo-ec2-e-inputs/
├── modules/
│   ├── vpc/
│   └── ec2/
│       ├── main.tofu          ← key pair, EIP, bastion, vm_private, SGs (dynamic blocks)
│       ├── variables.tofu     ← vpc_id, subnet_ids, vpc_cidr, instance_type, keypair_name, ami_id
│       └── outputs.tofu       ← bastion_ip, private_ip, sg_ids, keypair_arn
├── main.tofu                  ← module "vpc" + module "ec2" { vpc_id = module.vpc.vpc_id }
├── data.tofu
├── local.tofu
├── variables.tofu
├── outputs.tofu
└── providers.tofu
```

---

### 04.04 — Multi-env
**Delta vs 04.03:** Cria `envs/dev` e `envs/prod` chamando mesmos módulos.

**Estrutura:**
```
04.04-multi-env/
├── modules/
│   ├── vpc/
│   └── ec2/
├── envs/
│   ├── dev/
│   │   ├── main.tofu, providers.tofu, variables.tofu, terraform.tfvars, outputs.tofu
│   └── prod/
│       ├── main.tofu, providers.tofu, variables.tofu, terraform.tfvars, outputs.tofu
```

---

### 04.05 — Workspaces
**Delta:** Abordagem alternativa ao 04.04 com workspaces.

```
04.05-workspaces/
├── modules/ (vpc + ec2)
├── main.tofu, providers.tofu, variables.tofu, locals.tofu, outputs.tofu
```

---

### 04.06 — Dados Sensíveis
**Delta vs 04.05:** `sensitive = true` em variáveis, `.gitignore`, `terraform.tfvars.example`.

---

### 04.07 — Lifecycle e Boas Práticas
**Delta vs 04.06:** `lifecycle` blocks nos módulos (prevent_destroy, create_before_destroy, ignore_changes).

---

### 04.08 — Projeto: Infra AlgaDelivery Modularizada
**Projeto completo** consolidando 04.01–04.07:
```
04.08-projeto-infra-algadelivery-modularizada/
├── modules/ (vpc + ec2 com dynamic blocks, lifecycle)
├── envs/ (dev + prod)
├── .gitignore
└── terraform.tfvars.example
```

---

### PARTE 2 — Serviços Gerenciados com IaC (6 aulas)

Root module único chamando todos os módulos. Outputs de VPC alimentam RDS, ElastiCache e MSK.
Teste de conexão ao RDS via Bastion é feito dentro das aulas 04.10 e 04.11 (não precisa aula separada).

---

### 04.09 — Revisitando Desenho de Infra e Custos
**Aula teórica.** Código idêntico ao 04.08 (cópia). Foco no AWS Pricing Calculator.

---

### 04.10 — Entendendo e Provisionando RDS PostgreSQL via Console
**Conceito + Console + teste de conexão via Bastion.** Adiciona esqueleto do módulo RDS:
- `modules/rds/main.tofu` — `aws_db_parameter_group` + `aws_db_subnet_group` + SG (porta 5432)
- `modules/rds/variables.tofu` — db_name, username, password(sensitive), instance_class, subnet_ids, vpc_id, vpc_cidr
- `modules/rds/outputs.tofu` — esqueleto
- Sem `aws_db_instance` ainda (provisionado via Console nesta aula, teste via Bastion incluído)

---

### 04.11 — Provisionando RDS PostgreSQL via OpenTofu
**Delta vs 04.10:** Adiciona `aws_db_instance` no módulo RDS + teste de conexão via Bastion.

**Módulo `modules/rds/` completo:**
- `main.tofu` — `aws_db_subnet_group` + `aws_db_parameter_group` + `aws_db_instance` + SG (5432 do CIDR VPC)
- `variables.tofu` — db_name, db_username, db_password(sensitive), instance_class, engine_version, allocated_storage, subnet_ids, vpc_id, vpc_cidr
- `outputs.tofu` — endpoint, port, db_name, db_instance_id

**Root module (envs/dev/main.tofu):** adiciona `module "rds"` recebendo outputs de `module.vpc`.

---

### 04.12 — Entendendo e Provisionando ElastiCache Valkey
**Delta vs 04.11:** Adiciona módulo ElastiCache (conceito + Console + OpenTofu + teste numa aula).

**Novo módulo `modules/elasticache/`:**
- `main.tofu` — `aws_elasticache_subnet_group` + `aws_elasticache_replication_group` (engine=valkey) + SG (porta 6379)
- `variables.tofu` — node_type, num_cache_clusters, engine_version, subnet_ids, vpc_id, vpc_cidr
- `outputs.tofu` — primary_endpoint, port

**Root module:** adiciona `module "elasticache"`.

---

### 04.13 — Entendendo e Provisionando Amazon MSK (Kafka)
**Delta vs 04.12:** Adiciona módulo MSK (conceito + Console + OpenTofu + teste numa aula).

**Novo módulo `modules/msk/`:**
- `main.tofu` — `aws_msk_configuration` + `aws_msk_cluster` + SG (portas 9092/9094)
- `variables.tofu` — cluster_name, kafka_version, instance_type, ebs_volume_size, subnet_ids, vpc_id, vpc_cidr
- `outputs.tofu` — bootstrap_brokers_tls, zookeeper_connect

**Root module:** adiciona `module "msk"`.

---

### 04.14 — Testando Conectividade a Todos os Serviços
**Projeto final.** Consolida TUDO:

```
04.14-testando-conectividade-todos-servicos/
├── modules/
│   ├── vpc/
│   ├── ec2/
│   ├── rds/
│   ├── elasticache/
│   └── msk/
├── envs/
│   ├── dev/
│   │   ├── main.tofu          ← chama os 5 módulos
│   │   ├── providers.tofu
│   │   ├── variables.tofu
│   │   ├── terraform.tfvars
│   │   └── outputs.tofu       ← endpoints de todos os serviços
│   └── prod/
├── .gitignore
└── terraform.tfvars.example
```

**Fluxo de dados no root module:**
```
module.vpc.vpc_id              → module.ec2, module.rds, module.elasticache, module.msk
module.vpc.private_subnet_ids  → module.rds, module.elasticache, module.msk
module.vpc.public_subnet_ids   → module.ec2
module.vpc.vpc_cidr            → module.ec2, module.rds, module.elasticache, module.msk
```

---

## Execução

1. Criar pasta-raiz `04-modulos-e-servicos-gerenciados/`
2. Criar 14 subpastas (04.01 a 04.14)
3. Para cada aula, criar os arquivos .tofu com código incremental
4. Aula teórica/cópia: 04.09 recebe cópia do código da aula anterior

## Verificação

- Verificar que cada pasta tem arquivos .tofu válidos
- Verificar que referências entre módulos são consistentes
- Verificar que outputs do root module expõem endpoints de todos os serviços
