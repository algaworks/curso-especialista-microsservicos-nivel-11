# Sugestão de Divisão de Módulos — IaC na AWS

## Contexto

O módulo atual (Módulo 3) cobre fundamentos até projeto final em **44 aulas**.
O Módulo 4 planejado inclui rede (já coberta) + RDS + ElastiCache + MSK — o que geraria sobreposição.

Esta proposta unifica o conteúdo novo do Módulo 4 e redistribui tudo em **3 módulos coesos**, eliminando duplicação e mantendo tamanho equilibrado por módulo.

---

## Módulo 03 — Infraestrutura como Código (IaC) na AWS
> **~29 aulas** | Fases 0 a 5

### Objetivo
Sair do zero até ter uma VPC funcional com Bastion Host + EC2 privada acessível via SSH.

### Conteúdo

| # | Aula |
|---|------|
| 01 | Introdução + IaC + Benefícios |
| 02 | Terraform vs OpenTofu + Boas práticas |
| 03 | Setup do ambiente (OpenTofu + AWS CLI) |
| 04 | Provider AWS: autenticação e região |
| 05 | Primeiro recurso (S3) |
| 06 | Conhecendo os comandos básicos: plan / apply / destroy / fmt / validate |
| 07 | Trabalhando com variáveis |
| 08 | Gerando Outputs |
| 09 | Utilizando locals para organização de dados |
| 10 | Estrutura de arquivos |
| 11 | Explorando o arquivo tfstate |
| 12 | Backend remoto com S3 (locking nativo no OpenTofu 1.8+) |
| 13 | Criando uma VPC |
| 14 | Criando subnets públicas |
| 15 | Conhecendo Built-in functions |
| 16 | Criando Internet Gateway |
| 17 | Criando subnets privadas |
| 18 | Criando NAT Gateway |
| 19 | Configurando Route tables |
| 20 | Configurando associações das Route tables |
| 21 | Utilizando for_each |
| 22 | Utilizando count |
| 23 | Utilizando conditionals |
| 24 | Refatoração com variáveis |
| 25 | Criando Security Groups (Bastion + Private) |
| 26 | Entendendo Data sources (AZs disponíveis + AMI Ubuntu) |
| 27 | Criando EC2 Bastion |
| 28 | Criando EC2 privada |
| 29 | Teste SSH |
| 30 | Subnets dinâmicas |

**Entrega concreta:** VPC completa + Bastion + EC2 privada testada via SSH.

---

## Módulo 04 — IaC Avançado: Módulos, Escala e Multi-ambiente
> **~15 aulas** | Fases 6 a 10 + Projeto Final

### Objetivo
Transformar a infraestrutura básica em código production-grade: reutilizável, multi-ambiente e com práticas avançadas.

### Conteúdo

| # | Aula |
|---|------|
| 01 | Utilizando Dynamic blocks |
| 02 | Criando Módulo VPC |
| 03 | Inputs de módulos |
| 04 | Criando Módulo EC2 |
| 05 | Reuso de módulos |
| 06 | Multi-env (envs/dev + envs/prod) |
| 07 | Workspaces |
| 08 | Dados sensíveis |
| 09 | Boas práticas |
| 10 | Lifecycle |
| 11 | Import |
| 12 | State avançado |
| 13 | Debugging |
| 14 | Null resource |
| 15 | Projeto: Infraestrutura modularizada e multi-ambiente do AlgaDelivery |

**Entrega concreta:** VPC e EC2 via módulos reutilizáveis, security groups com dynamic blocks, variáveis sensíveis, deployment em `dev` e `prod` via workspaces, lifecycle `prevent_destroy` no Bastion, `null_resource` para validação pós-deploy e outputs de endpoints prontos para consumo no Módulo C via remote state.

---

## Módulo 05 — Provisionando Serviços Gerenciados da AWS com IaC
> **~13 aulas** | Conteúdo novo do Módulo 4

### Objetivo
Provisionar os serviços de dados do AlgaDelivery (banco, cache, mensageria) via OpenTofu, integrando ao projeto já existente.

### Conteúdo

| # | Aula |
|---|------|
| 01 | Revisitando o desenho de infra do AlgaDelivery |
| 02 | Estimando custos com AWS Pricing Calculator |
| 03 | Network ACLs com OpenTofu |
| 04 | Introdução ao RDS e parameter groups |
| 05 | Provisionando RDS PostgreSQL via AWS Console |
| 06 | Provisionando RDS PostgreSQL via OpenTofu |
| 07 | Testando conexão ao RDS via Bastion Host |
| 08 | Introdução ao ElastiCache Redis/Valkey |
| 09 | Provisionando ElastiCache Valkey via AWS Console |
| 10 | Provisionando ElastiCache Valkey via OpenTofu |
| 11 | Introdução ao Amazon MSK (Kafka) |
| 12 | Provisionando Amazon MSK via AWS Console |
| 13 | Provisionando Amazon MSK via OpenTofu |

**Entrega concreta:** RDS PostgreSQL + ElastiCache Valkey + Amazon MSK provisionados via código e acessíveis pelo Bastion.

---

## Resumo

| Módulo | Foco | Aulas |
|--------|------|-------|
| 03 — IaC na AWS | Zero → VPC + EC2 funcionando | ~29 |
| 04 — IaC Avançado | Código production-grade + projeto final | ~15 |
| 05 — Serviços Gerenciados AWS com IaC | RDS + ElastiCache + MSK | ~13 |
| **Total** | | **~57** |

### Por que essa divisão funciona

- **Tamanho equilibrado**: 13–26 aulas por módulo — faixa saudável para retenção
- **Fronteiras didáticas claras**: cada módulo termina com uma entrega concreta e testável
- **Zero sobreposição**: o conteúdo de rede do Módulo 4 original é absorvido no Módulo A
- **Progressão natural**: fundamentos → padrões avançados → serviços do projeto real
