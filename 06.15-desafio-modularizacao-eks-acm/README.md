# 6.15 · Desafio: modularizando o EKS e o ACM

Ponto de partida: o código da `06.14`, com o EKS espalhado em cinco arquivos `eks*.tofu` e o ACM em `acm.tofu`,
todos na raiz. O desafio é levar isso para o mesmo padrão de `modules/vpc`, `modules/rds` etc. — e **sem
destruir o cluster que já está no ar**.

## O que mudou

```
modules/
├── eks/                      # tudo o que era eks*.tofu na raiz
│   ├── main.tofu             # cluster, role do control plane, log group
│   ├── security_group.tofu   # SG adicional do cluster
│   ├── node_group.tofu       # node group + role dos nodes
│   ├── oidc.tofu             # OIDC provider (base do IRSA)
│   ├── addons.tofu           # add-ons gerenciados + EBS CSI com IRSA
│   ├── storage_class.tofu    # StorageClass gp3 default
│   ├── alb_controller.tofu   # IAM + IRSA + helm_release do AWS LB Controller
│   ├── policy/iam_policy.json
│   ├── local.tofu  variables.tofu  outputs.tofu
└── acm/                      # tudo o que era acm.tofu
    ├── main.tofu             # certificado + espera da validação
    ├── dns_validation.tofu   # records de validação na Cloudflare
    ├── versions.tofu         # required_providers: cloudflare NÃO é hashicorp/
    └── variables.tofu  outputs.tofu
```

Na raiz sobram `eks.tofu` e `acm.tofu`, só com a chamada `module "eks"` / `module "acm"`.
Os providers `kubernetes` e `helm` passam a ler `module.eks.cluster_endpoint` e
`module.eks.cluster_certificate_authority_data`.

## As três pegadinhas do desafio

1. **Endereço novo = recurso novo.** Para o OpenTofu, `aws_eks_cluster.main` e `module.eks.aws_eks_cluster.main`
   são coisas diferentes. Sem migrar o state, o plan quer destruir o cluster e criar outro.
   → [`docs/migration-eks-cluster.md`](docs/migration-eks-cluster.md) (22 `tofu state mv`, com backup e rollback).
2. **O módulo tem que ser uma cópia fiel.** Nome, tag, chave de `for_each`: qualquer diferença vira
   `update` ou, pior, `must be replaced`. A meta é `tofu plan` sem nada de `module.eks`/`module.acm`.
3. **`path.module` muda de significado.** Dentro do módulo ele aponta para `modules/eks/`, por isso o
   `iam_policy.json` foi junto.

## Valores do ambiente

O `dev.tfvars` fica fora do Git. Crie o seu a partir do modelo e troque o `cloudflare_zone_id` pelo da sua zona:

```bash
cp example.tfvars dev.tfvars
```

## Token da Cloudflare

Saiu do `dev.tfvars`. A variável agora é `sensitive` e sem `default`:

```bash
read -s TF_VAR_cloudflare_api_token && export TF_VAR_cloudflare_api_token
```

## Atenção

A `06.14` e a `06.15` usam a **mesma key** de state no S3. Depois da migração, opere só pela `06.15`:
um `apply` na `06.14` tentaria recriar tudo.
