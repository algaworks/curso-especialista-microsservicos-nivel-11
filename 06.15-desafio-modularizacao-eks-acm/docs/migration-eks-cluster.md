# Migração do state: da raiz (6.14) para `module.eks` e `module.acm`

**Objetivo:** levar o cluster que **já existe** para dentro dos módulos **sem destruir nada**. O
`tofu state mv` só renomeia o endereço do recurso dentro do state: ele não chama a AWS, não recria e não
apaga nada.

**Critério de sucesso:** no fim, o `tofu plan` responde `No changes`.

> Rode **tudo** de dentro de `06.15-desafio-modularizacao-eks-acm/`.

## 0. Preparação

O token da Cloudflare não fica no `dev.tfvars`:

```bash
read -s TF_VAR_cloudflare_api_token && export TF_VAR_cloudflare_api_token
```

> ⚠️ `-var-file` tem precedência sobre `TF_VAR_*`. Se o `dev.tfvars` ainda tiver uma linha
> `cloudflare_api_token`, o tofu usa **ela**, e não o `TF_VAR_`.

```bash
tofu init -reconfigure -var-file=dev.tfvars
```

Faça o backup do state **antes** de mexer. Ele é o seu botão de desfazer (passo 7):

```bash
tofu state pull > backup-antes-da-migracao.tfstate
```

Tire a foto do "antes". O plan quer **criar** tudo de novo dentro dos módulos, e é exatamente isso que a
migração vai evitar. **Não rode `apply` aqui.**

```bash
tofu plan -var-file=dev.tfvars -target=module.eks -target=module.acm
```

## 1. Cluster, IAM do control plane, security group e log group

Arquivos: `modules/eks/main.tofu` e `modules/eks/security_group.tofu`.

```bash
tofu state mv aws_eks_cluster.main                      module.eks.aws_eks_cluster.main
tofu state mv aws_iam_role.cluster                      module.eks.aws_iam_role.cluster
tofu state mv aws_iam_role_policy_attachment.cluster    module.eks.aws_iam_role_policy_attachment.cluster
tofu state mv aws_security_group.cluster                module.eks.aws_security_group.cluster
tofu state mv aws_cloudwatch_log_group.cluster          module.eks.aws_cloudwatch_log_group.cluster
```

## 2. Node group

Arquivo: `modules/eks/node_group.tofu`. O `node_group_role_attachment` tem `for_each`: mover **sem** a chave
leva as 3 instâncias de uma vez.

```bash
tofu state mv aws_iam_role.node_group                                   module.eks.aws_iam_role.node_group
tofu state mv aws_iam_role_policy_attachment.node_group_role_attachment module.eks.aws_iam_role_policy_attachment.node_group_role_attachment
tofu state mv aws_eks_node_group.default                                module.eks.aws_eks_node_group.default
```

## 3. OIDC, add-ons, IRSA do EBS CSI e StorageClass

Arquivos: `modules/eks/oidc.tofu`, `addons.tofu` e `storage_class.tofu`. O `aws_eks_addon.main` tem
`for_each`: as 4 instâncias vão juntas.

```bash
tofu state mv aws_iam_openid_connect_provider.eks                 module.eks.aws_iam_openid_connect_provider.eks
tofu state mv aws_eks_addon.main                                  module.eks.aws_eks_addon.main
tofu state mv aws_eks_addon.csi_driver                            module.eks.aws_eks_addon.csi_driver
tofu state mv aws_iam_role.eks_addon_csi_driver                   module.eks.aws_iam_role.eks_addon_csi_driver
tofu state mv aws_iam_role_policy_attachment.eks_addon_csi_driver module.eks.aws_iam_role_policy_attachment.eks_addon_csi_driver
tofu state mv kubernetes_storage_class_v1.gp3                     module.eks.kubernetes_storage_class_v1.gp3
tofu state mv kubernetes_annotations.gp2_not_default              module.eks.kubernetes_annotations.gp2_not_default
```

## 4. AWS Load Balancer Controller

Arquivo: `modules/eks/alb_controller.tofu`.

```bash
tofu state mv aws_iam_policy.alb_controller                  module.eks.aws_iam_policy.alb_controller
tofu state mv aws_iam_role.alb_controller                    module.eks.aws_iam_role.alb_controller
tofu state mv aws_iam_role_policy_attachment.alb_controller  module.eks.aws_iam_role_policy_attachment.alb_controller
tofu state mv helm_release.alb_controller                    module.eks.helm_release.alb_controller
```

## 5. ACM e validação na Cloudflare

Arquivos: `modules/acm/`. O `cloudflare_dns_record.validation` tem `for_each` (chave = `domain_name`).

```bash
tofu state mv aws_acm_certificate.main             module.acm.aws_acm_certificate.main
tofu state mv cloudflare_dns_record.validation     module.acm.cloudflare_dns_record.validation
tofu state mv aws_acm_certificate_validation.main  module.acm.aws_acm_certificate_validation.main
```

## 6. Conferir

Não pode sobrar nenhum `aws_eks_*`, `aws_iam_*`, `helm_*`, `kubernetes_*` ou `aws_acm_*` na raiz:

```bash
tofu state list
```

Sobram só os data sources. O `data.tls_certificate.oidc` fica órfão na raiz, e o próprio OpenTofu o descarta
no próximo `apply`, porque data source não cria nada.

Chega a hora da verdade: nada de `module.eks` nem de `module.acm` pode aparecer.

```bash
tofu plan -var-file=dev.tfvars -target=module.eks -target=module.acm
```

```
No changes. Your infrastructure matches the configuration.
```

> 🛑 Se aparecer **qualquer** `must be replaced` ou `will be destroyed`: **pare**. Não rode `apply`. Compare o
> atributo apontado no plan com o código da 6.14 e corrija o módulo até o plan voltar limpo.

Sem o `-target`, o plan também lista bastion, RDS, ElastiCache e MSK como `will be created`. **Isso não vem da
migração:** no lab, esses módulos nunca foram aplicados (o state só tem VPC + EKS + ACM). A 6.14 mostraria o
mesmo.

## 7. Desfazer

Só funciona se algo der errado **antes** do `apply`. Devolve o state exatamente como estava no passo 0:

```bash
tofu state push -force backup-antes-da-migracao.tfstate
```

## Atenção

- **Migrar pela metade é pior do que não migrar.** Com só o cluster movido, o plan responde
  `module.eks.aws_eks_cluster.main must be replaced`. O motivo é que o `role_arn` dele aponta para
  `module.eks.aws_iam_role.cluster`, que ainda não está no state, e por isso vira `(known after apply)`. Um
  `apply` nesse meio-termo **recria o cluster**, mesmo com `-target`. Termine todos os `state mv` antes de
  qualquer `apply`.
- **A 6.14 e a 6.15 usam a mesma key de state no S3.** Depois desta migração, um `tofu apply` na pasta da 6.14
  veria os recursos da raiz como novos e tentaria recriar tudo. A partir daqui, opere só pela 6.15.
- **Apague o `backup-antes-da-migracao.tfstate`** quando o plan estiver limpo. Ele é um state completo; o
  `.gitignore` cobre `*.tfstate`, mas não deixe o arquivo solto.

## Alternativa declarativa: blocos `moved`

Em vez de rodar comandos, dá para declarar a migração no código, com um bloco por recurso:

```hcl
moved {
  from = aws_eks_cluster.main
  to   = module.eks.aws_eks_cluster.main
}
```

O efeito no state é o mesmo. A diferença é que **fica versionado no Git** e só acontece **no próximo `apply`**.
