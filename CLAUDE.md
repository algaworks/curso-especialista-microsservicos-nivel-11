# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Course repository for **"Microsserviços em Produção na AWS — Nível 11"** (Algaworks). The practical project is **AlgaDelivery**, a microservices platform deployed on AWS. Each numbered directory (e.g. `03.07-trabalhando-com-variaveis/`) is a self-contained snapshot for a specific lesson, incrementally building on the previous one. All infrastructure is written in **OpenTofu** (`.tofu` files).

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

- **Module 3 (03.XX):** OpenTofu fundamentals — flat structure, single directory with `main.tofu`, `variables.tofu`, `outputs.tofu`, `providers.tofu`
- **Module 4 (04.XX):** Modularization and managed services — evolves toward the pattern below

### Module 4 Final Structure (from `04.07-explorando-multi-env` onward)

```
<lesson>/
├── modules/
│   ├── vpc/       # VPC, subnets (public/private), IGW, NAT Gateway, route tables
│   └── ec2/       # Key pair (TLS generated), EIP, EC2 instance, security group
├── envs/
│   ├── dev/       # Root module for development environment
│   └── prod/      # Root module for production environment
```

Each `envs/<env>/` directory is an independent root module containing: `main.tofu`, `vpc.tofu`, `ec2.tofu`, `data.tofu`, `local.tofu`, `variables.tofu`, `outputs.tofu`, `providers.tofu`.

### Module Data Flow

```
module.vpc.vpc_id            → module.ec2 (security groups, instance placement)
module.vpc.public_subnet_ids → module.ec2 (bastion host placement)
module.vpc.vpc_cidr          → module.ec2 (security group CIDR rules)
```

### Remote State

State is stored in S3. The backend is configured in `providers.tofu`:
- Bucket: `algadelivery-tfstate`
- Key: `algadelivery/${var.environment}/remote.tfstate`

### Key Design Patterns

- **`common_tags`** local propagates `Environment` and `ManagedBy = "OpenTofu"` to all resources via `merge(var.common_tags, { Name = "..." })`
- **Dynamic blocks** for security group ingress/egress rules — rules are passed as `list(object({...}))` variables
- **`ngw_regional_mode`**: boolean variable translated to `"regional"` or `"zonal"` in locals, controlling NAT Gateway availability mode
- **`lifecycle { prevent_destroy = true; ignore_changes = [ami] }`** on EC2 instances starting from `04.08-utilizando-o-lifecycle`
- **SSH key pairs** are generated at apply time via `tls_private_key` + `aws_key_pair` + `local_sensitive_file` (`.pem` written to `path.root`, gitignored)
- **My public IP** is fetched dynamically via `data.http.my_public_ip` and used in bastion SSH rules

### Providers (Module 4)

| Provider | Version | Use |
|---|---|---|
| `hashicorp/aws` | `~> 6.0` | All AWS resources |
| `hashicorp/http` | `~> 3.0` | Fetch caller's public IP |
| `hashicorp/tls` | `~> 4.0` | Generate RSA key pairs |
| `hashicorp/local` | `~> 2.0` | Write `.pem` files to disk |

## .gitignore Rules

The following are excluded and must never be committed:
- `.terraform/`, `.terraform.lock.hcl`
- `*.tfstate`, `*.tfstate.backup`
- `*.tfvars`, `*.tfvars.json` (use `*.example.tfvars` for templates)
- `*.pem` (generated SSH private keys)
- `*.tfplan`, `*.plan`
