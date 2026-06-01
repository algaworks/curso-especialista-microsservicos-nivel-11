# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Course repository for **"Microsserviços em Produção na AWS — Nível 11"** (Algaworks). The practical project is **AlgaDelivery**, a microservices platform deployed on AWS. Each numbered directory (e.g. `03.07-trabalhando-com-variaveis/`) is a self-contained snapshot for a specific lesson, incrementally building on the previous one. All infrastructure is written in **OpenTofu** (`.tofu` files).

The full course outline lives in `EMENTA-NIVEL-11-AWS.md` — treat that as the source of truth for module/lesson structure.

## Course Structure (10 modules)

| # | Module | Status | Aulas |
|---|---|---|---|
| 1 | Fundamentos de Cloud Computing | 🎥 em gravação | 13 |
| 2 | Fundamentos de Redes na AWS | ✅ finalizado | 19 |
| 3 | Infraestrutura como Código (IaC) na AWS | ✅ finalizado | 21 |
| 4 | IaC Modular e Serviços Gerenciados na AWS | ✅ finalizado | 21 |
| 5 | Dominando orquestração de containers com Kubernetes | 📋 ementa planejada | 41 |
| 6 | Provisionando o cluster EKS na AWS com OpenTofu | 📋 ementa planejada | 20 |
| 7 | Ferramentas de Deploy e GitOps | 📋 ementa planejada | 25 |
| 8 | Configuração Externalizada e Gestão de Segredos | 📋 ementa planejada | 10 |
| 9 | Deploy Completo do AlgaDelivery na AWS | 📋 ementa planejada | 12 |
| 10 | Apêndice — Deploy Algashop | 📋 ementa planejada | — |

**Narrative arc:** Cloud foundations → AWS networking → IaC fundamentals → Modular IaC + managed services → Kubernetes (local with Kind) → **Provision EKS** → Deploy tooling (Helm/Kong/ArgoCD) → External config → Deploy AlgaDelivery on real infra → Appendix.

## Pedagogical Principles

These principles emerged from the course design and should guide content/code suggestions:

1. **Conceito → Implementação** — abstract concepts are taught immediately before their concrete implementation, not separately:
   - Module 5 opens with VMs/Containers/CNCF/Service Instance Patterns as the *argumentative buildup* to "por isso K8s exists"
   - **Failover** (concept) is taught right before **ReplicaSet** (5.16, the K8s primitive that implements it)
   - **Self Healing** (concept) is taught right before **Probes** (5.37, the mechanism that implements it)
2. **Console first, then IaC** — many AWS services are introduced manually via Console, then re-provisioned with OpenTofu. Pattern visible in Module 4 (RDS, ElastiCache, MSK), continues in Module 6 (EKS, node groups, add-ons, EBS CSI, ACM).
3. **No mini-labs** in Module 1 — only the final challenge (`1.13. Desafio: desenhar arquitetura on-premise vs cloud`). All hands-on starts from Module 2.
4. **Module 4 has two challenges** — `4.16 Desafio: Criando Módulo ElastiCache` and `4.19 Desafio: Modulo MSK`. Pattern: provide the service hands-on first, then challenge the student to modularize it.
5. **Cloud concepts stay in Module 1; compute primitives go to Module 5** — VMs, Containers, CNCF, and Service Instance Patterns moved to Module 5 opening so they're contiguous with K8s. Module 1 is now exclusively "what is cloud + operational properties + when to migrate."
6. **Network basics stay in Module 2, not duplicated in Module 1** — Module 2.05 (VPC fundamentals) and Module 2.06 (CIDR) cover IP/DNS/subnets, so Module 1 omits them.

### Known gaps (intentional, not omissions)

- **Observability** — will be introduced at the very end of the course (after Module 10 — Algashop). Not in Module 1.
- **IAM** — introduced pointwise in Modules 5/6/8 only where needed; no dedicated module.
- **FinOps** — only `1.07 Modelos de precificação`; no deeper coverage planned.

## OpenTofu Commands

All commands use `tofu`, not `terraform`.

```bash
tofu init       # initialize providers and modules
tofu validate   # validate configuration syntax
tofu fmt -recursive  # format all .tofu files
tofu plan       # preview changes
tofu apply      # apply changes
tofu destroy    # destroy all resources
```

For lessons with the multi-environment structure (`envs/dev`, `envs/prod`), run commands from inside the environment directory:

```bash
cd <lesson>/envs/dev
tofu init
tofu plan
tofu apply
```

## Architecture

### Lesson Progression

- **Module 3 (03.XX) — Infraestrutura como Código (IaC) na AWS:** OpenTofu fundamentals + provisioning a complete network from scratch. Flat structure, single directory with `main.tofu`, `variables.tofu`, `outputs.tofu`, `providers.tofu`. Builds up to: VPC + public/private subnets + IGW + NAT Gateway + route tables + Security Groups (Bastion + Private) + EC2 (public + private), all via OpenTofu. Ends with connectivity tests and destroy.
- **Module 4 (04.XX) — IaC Modular e Serviços Gerenciados na AWS:** Modularization (dynamic blocks, for expressions, lifecycle) and managed services. Introduces `modules/vpc`, `modules/ec2`, `modules/rds`, `modules/elasticache`, `modules/msk`. Multi-env structure (`envs/dev`, `envs/prod`) from `04.07-explorando-multi-env` onward.

### Lesson Directory Naming

Directories follow `<MM>.<NN>-<kebab-case-title>/`:
- `03.07-trabalhando-com-variaveis/`
- `04.13-configurando-backup-e-manutencao-no-rds/`

Numbering follows the ementa. Occasional `*-final/` variants indicate the "after fixing" state of an aula (e.g. `04.13-configurando-backup-e-manutencao-no-rds-final/`).

### Module 4 Final Structure (from `04.07-explorando-multi-env` onward)

```
<lesson>/
├── modules/
│   ├── vpc/          # VPC, subnets (public/private), IGW, NAT Gateway, route tables
│   ├── ec2/          # Key pair (TLS generated), EIP, EC2 instance, security group
│   ├── rds/          # RDS PostgreSQL: parameter groups, backup, maintenance window, secure password
│   ├── elasticache/  # ElastiCache Valkey
│   └── msk/          # Amazon MSK (Kafka)
├── envs/
│   ├── dev/          # Root module for development environment
│   └── prod/         # Root module for production environment
```

Each `envs/<env>/` directory is an independent root module. Composition files grow as modules are added: `main.tofu`, `vpc.tofu`, `ec2.tofu`, `rds.tofu`, `elasticache.tofu`, `msk.tofu`, `data.tofu`, `local.tofu`, `variables.tofu`, `outputs.tofu`, `providers.tofu`.

### Module Data Flow

```
module.vpc.vpc_id             → module.ec2, module.rds, module.elasticache, module.msk (placement, SG)
module.vpc.public_subnet_ids  → module.ec2 (bastion host placement)
module.vpc.private_subnet_ids → module.rds, module.elasticache, module.msk (private placement)
module.vpc.vpc_cidr           → module.ec2, module.rds, module.elasticache, module.msk (SG CIDR rules)
```

### Remote State

State is stored in S3. The backend is configured in `providers.tofu`:
- Bucket: `algadelivery-tfstate`
- Key: `algadelivery/${var.environment}/remote.tfstate`

### Key Design Patterns

- **`common_tags`** local propagates `Environment` and `ManagedBy = "OpenTofu"` to all resources via `merge(var.common_tags, { Name = "..." })`
- **Dynamic blocks** for security group ingress/egress rules — rules are passed as `list(object({...}))` variables (introduced `04.02-utilizando-dynamic-blocks`)
- **For expressions and type constraints** introduced in `04.04-tipos-de-coleção-e-for-expressions`
- **`ngw_regional_mode`**: boolean variable translated to `"regional"` or `"zonal"` in locals, controlling NAT Gateway availability mode
- **`lifecycle { prevent_destroy = true; ignore_changes = [ami] }`** on EC2 instances starting from `04.08-utilizando-o-lifecycle`
- **SSH key pairs** are generated at apply time via `tls_private_key` + `aws_key_pair` + `local_sensitive_file` (`.pem` written to `path.root`, gitignored)
- **My public IP** is fetched dynamically via `data.http.my_public_ip` and used in bastion SSH rules
- **RDS secure passwords**: managed via `random_password` (introduced in `04.11-gerenciando-senhas-com-segurança-no-rds`) — never committed; sensitive outputs
- **RDS backup & maintenance window**: configured via dedicated module variables from `04.13-configurando-backup-e-manutencao-no-rds` onward

### Providers (Module 4 — current)

| Provider | Version | Use |
|---|---|---|
| `hashicorp/aws` | `~> 6.0` | All AWS resources (VPC, EC2, RDS, ElastiCache, MSK, etc.) |
| `hashicorp/http` | `~> 3.0` | Fetch caller's public IP |
| `hashicorp/tls` | `~> 4.0` | Generate RSA key pairs |
| `hashicorp/local` | `~> 2.0` | Write `.pem` files to disk |
| `hashicorp/random` | `~> 3.0` | Generate secure RDS passwords |

### Planned Providers (Modules 5+)

| Provider | When introduced | Use |
|---|---|---|
| `hashicorp/kubernetes` | Module 6 (EKS setup) | Kubernetes resources (namespaces, service accounts, etc.) |
| `hashicorp/helm` | Module 6 (Kong install at `6.19`) → enforced from `7.10` onward | All Helm releases provisioned via IaC, not Helm CLI |

## Planned Modules (not yet recorded)

### Module 5 — Kubernetes (local with Kind)

Opens with a **conceptual bridge** (compute primitives → orchestration patterns → K8s):
- `5.01–5.03` VMs, Containers, Containers vs VMs
- `5.04` Cloud Native + ecossistema CNCF
- `5.05–5.07` Service Instance Patterns (Host → VM → Container) — argues the *need* for K8s
- `5.08` K8s architecture, Control Plane, Worker Nodes
- `5.09` Setup: kubectl + Kind + cluster local
- `5.10+` Workloads, services, networking, scheduling, storage, RBAC

Two concept-implementation pairings in the body:
- `5.12` Failover (concept) → `5.13` ReplicaSet (implementation)
- `5.30` Self Healing com Readiness, Liveness e Startup Probes (merged)

### Module 6 — Provisionando o cluster EKS na AWS com OpenTofu

Pure infrastructure provisioning before any application deploy. Each managed component follows the **Console → OpenTofu** pattern:
- EKS cluster, node groups, add-ons, EBS CSI Driver
- NGINX Ingress Controller via OpenTofu
- Service LoadBalancer with NLB
- Cloudflare (DNS for cluster)
- ACM (TLS certificates) + HTTPS on Ingress
- **Kong API Gateway** provisioned here (`6.19`) — moved from old Module 8 since installation is infrastructure, route/plugin config stays in Module 9
- Rancher (optional cluster management UI)

### Module 7 — Ferramentas de Deploy e GitOps

**Critical rule:** from aula `7.10` onward, **any Helm install must use the OpenTofu Helm provider, not the Helm CLI.** Lesson titles reflect this:
- `7.10 Instalando Kong Gateway com Helm provider no OpenTofu`
- `7.18 Instalando ArgoCD via Helm provider no OpenTofu`
- `7.25 Apêndice: Argo Rollouts via Helm provider no OpenTofu para deployments avançados`

`7.06–7.08` still teach Helm CLI conceptually (chart anatomy, `helm install/upgrade/rollback`), but every actual install in the course from `7.10` is IaC.

### Module 9 — Deploy AlgaDelivery (uses the prepared infra from Module 6)

Slim module (12 aulas). Focuses on USING the infrastructure already provisioned in Module 6 — does NOT re-install Kong or set up clusters:
- Kong **routes/plugins** for microservices (the Kong instance was installed in `6.19`)
- AlgaDelivery-specific config externalization (Parameter Store)
- Helm Charts of the AlgaDelivery app + values for multi-env
- ArgoCD installation (`9.08`) + AlgaDelivery Application registration
- Full GitOps pipeline + production test

## Working with This Repo

### When asked to create a new lesson directory

1. Confirm the lesson number and title against `EMENTA-NIVEL-11-AWS.md`
2. Copy structure from the previous adjacent lesson (lessons are incremental snapshots)
3. Apply ONLY the diff described by the lesson title — do not refactor unrelated files
4. Use the naming convention `<MM>.<NN>-<kebab-case-title>/`

### When working on Module 5+ code (planned)

- These directories don't exist yet. If asked to scaffold, follow the existing pattern (incremental snapshots, one dir per aula).
- For Helm releases in Modules 6/7/9, default to `helm_release` resources via OpenTofu, NOT `helm install` shell commands.

### When updating the ementa

The ementa file (`EMENTA-NIVEL-11-AWS.md`) tracks module status badges:
- 🎥 _em gravação_ — Module 1 currently
- ✅ _finalizado_ — Modules 2, 3, 4
- 📋 _ementa planejada_ — Modules 5–10

Renumbering modules is fragile because aula numbers `M.NN` repeat across modules. Edit modules in reverse order (highest first) to avoid collisions.

## .gitignore Rules

The following are excluded and must never be committed:
- `.terraform/`, `.terraform.lock.hcl`
- `*.tfstate`, `*.tfstate.backup`
- `*.tfvars`, `*.tfvars.json` (use `*.example.tfvars` for templates)
- `*.pem` (generated SSH private keys)
- `*.tfplan`, `*.plan`
