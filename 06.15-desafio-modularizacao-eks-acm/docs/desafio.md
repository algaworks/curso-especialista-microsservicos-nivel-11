# Desafio 6.15 · Modularizando o EKS e o ACM sem derrubar o cluster

## Contexto

Na aula 6.14 o cluster EKS ficou pronto: node group, add-ons, EBS CSI Driver, AWS Load Balancer Controller e
um certificado do ACM validado na Cloudflare. Funciona, mas o código cresceu do jeito que deu, e são seis
arquivos soltos na raiz do projeto:

| Arquivo | Conteúdo |
|---|---|
| `eks.tofu` | cluster, role do control plane, security group, log group |
| `eks_node_group.tofu` | node group e a role dos nodes |
| `eks_addons.tofu` | add-ons, OIDC provider e a role IRSA do EBS CSI |
| `eks_storage_class.tofu` | StorageClass `gp3` default |
| `eks_alb_controller.tofu` | policy, role IRSA e `helm_release` do controller |
| `acm.tofu` | certificado, records de validação na Cloudflare e a espera da validação |

Desde o Módulo 4, todo serviço tem o seu módulo em `modules/` (`vpc`, `ec2`, `rds`, `elasticache`, `msk`), e a
raiz só faz a composição. O EKS e o ACM são os únicos fora desse padrão.

> ⚠️ **Há um detalhe que muda tudo: o cluster já está no ar.** No lab, dá para destruir e recriar. Em
> produção, isso seria derrubar todas as aplicações. Você pode recriar do zero, desde que destrua o cluster antigo
> antes. Levar o cluster existente para o módulo **sem destruir nada** é o caminho B da etapa 4, opcional, e é
> o diferencial do desafio.

## O que você precisa fazer

Parta de uma cópia do código da 6.14.

### 1. Crie o módulo `modules/eks/`

- Leve para dentro dele **todo** o conteúdo dos arquivos `eks*.tofu`.
- Organize-o como os módulos anteriores: arquivos separados por assunto, um `variables.tofu` e um `outputs.tofu`.
- O que vinha de fora (`module.vpc`, locals da raiz, `var.aws_region`) passa a entrar como **variável do
  módulo**. O módulo não pode referenciar nada da raiz diretamente.
- Receba as tags por uma variável `common_tags`, como nos outros módulos.
- Exponha como output tudo o que a raiz e os providers precisam: nome e endpoint do cluster, certificado da
  CA, ARN do OIDC provider, roles etc.

### 2. Crie o módulo `modules/acm/`

- Leve para dentro dele todo o conteúdo de `acm.tofu`.
- Exponha como output, no mínimo, o **ARN do certificado validado**. É ele que vai na anotação
  `alb.ingress.kubernetes.io/certificate-arn` do Ingress.

### 3. Ajuste a raiz

- No lugar dos seis arquivos, ficam só as chamadas `module "eks"` e `module "acm"`.
- Os providers `kubernetes` e `helm`, e o `data "aws_eks_cluster_auth"`, passam a ler os valores **do
  módulo**, e não mais dos recursos.
- Os outputs da raiz passam a repassar os outputs dos módulos.

### 4. Suba o código modularizado: escolha um caminho

O código novo não sabe que o cluster antigo existe. Há dois jeitos de resolver isso:

**Caminho A: recriar do zero.** Destrua o ambiente da 6.14 e aplique o código novo:

```bash
# na pasta da 6.14
kubectl delete ingress --all -A          # espere o ALB sumir no Console
tofu destroy -var-file=dev.tfvars

# na pasta do desafio
tofu apply -var-file=dev.tfvars
```

Funciona, e no lab é perfeitamente aceitável. É o que **não se faz** com um cluster de produção: todas as
aplicações caem durante a troca.

**Caminho B *(opcional, o diferencial)*: migrar o state sem destruir nada.** O cluster que está no ar passa
para os módulos sem ser tocado. Use `tofu state mv` para levar cada recurso do endereço antigo (raiz) para o
novo (dentro do módulo). Antes de mexer, faça um **backup do state**.

> A resolução passo a passo deste caminho está em [`migration-eks-cluster.md`](migration-eks-cluster.md).
> Tente primeiro sozinho e use o arquivo para conferir.

### 5. Não mude o comportamento

Modularizar é mudar a **organização**, não o **resultado**. Nenhum nome, tag, chave de `for_each` ou parâmetro
pode mudar no caminho. Se você achar um bug no código original, anote-o e corrija **depois**, numa mudança
separada.

## Critério de aceite

**Para todos:**

- [ ] `tofu fmt -check -recursive` não aponta arquivos para formatar
- [ ] `tofu validate` responde `Success`
- [ ] `tofu state list` não mostra nenhum `aws_eks_*`, `aws_iam_*`, `helm_release`, `kubernetes_*` ou
      `aws_acm_*` na raiz: tudo está dentro de `module.eks` ou `module.acm`
- [ ] `kubectl get nodes` mostra os nodes `Ready`
- [ ] o Ingress com HTTPS da 6.14 responde no navegador

**Para quem seguiu o caminho B (migração do state):**

- [ ] `tofu plan -var-file=dev.tfvars -target=module.eks -target=module.acm` responde:
      ```
      No changes. Your infrastructure matches the configuration.
      ```
- [ ] os nodes são os **mesmos** de antes (mesmo nome, mesma idade no `kubectl get nodes`)

> 🛑 Se o `plan` mostrar `must be replaced` ou `will be destroyed` em qualquer recurso do EKS ou do ACM, a
> migração **não terminou**. Não rode `apply`.

## Entregáveis

- `modules/eks/`: o módulo do EKS
- `modules/acm/`: o módulo do ACM
- `eks.tofu` e `acm.tofu` na raiz, só com a chamada do módulo
- *(caminho B)* a saída do `tofu plan` do critério de aceite

## Dicas (leia se travar)

<details>
<summary>Por que não dá para só mover os arquivos?</summary>

Para o OpenTofu, `aws_eks_cluster.main` e `module.eks.aws_eks_cluster.main` são recursos **diferentes**. Rode
o `plan` antes de migrar e repare no que ele quer fazer com o seu cluster. É por isso que a migração existe.
</details>

<details>
<summary>Movi o cluster, mas o plan ainda quer recriá-lo</summary>

Mover só uma parte não basta. Um recurso já movido continua dependendo dos que ficaram para trás e pode ser
recriado por causa deles. Migre **tudo** antes de qualquer `apply`.
</details>

<details>
<summary>Recursos com <code>for_each</code></summary>

Add-ons, policy attachments e records de validação podem ser movidos de uma vez, **sem** a chave entre
colchetes.
</details>

<details>
<summary>O controller não acha o JSON da policy</summary>

`path.module` muda de significado dentro de um módulo. Confira de onde o controller está lendo o JSON da
policy.
</details>

<details>
<summary>O módulo do ACM não acha o provider da Cloudflare</summary>

O provider da Cloudflare não é `hashicorp/`. Um módulo que usa esse provider precisa dizer de onde ele vem.
</details>

<details>
<summary>Cuidado com o nome do cluster</summary>

O nome do cluster aparece em vários lugares: nas tags do ALB, no IRSA, no `update-kubeconfig`. Se ele mudar,
você não modularizou: você criou outro cluster.
</details>

<details>
<summary>Depois de migrar, qual pasta usar?</summary>

A 6.14 e a 6.15 usam a **mesma key de state** no S3. Depois de migrar, opere só pela pasta nova: um `apply` na
antiga tentaria recriar tudo.
</details>

<details>
<summary>Token da Cloudflare</summary>

Segredo não entra em arquivo `.tfvars`. O token vai por `TF_VAR_cloudflare_api_token`. E lembre que
`-var-file` tem precedência sobre `TF_VAR_*`: se o token também estiver no tfvars, é o do tfvars que vale.
</details>

## Desafio extra (para quem seguiu o caminho B)

Refaça a migração de outro jeito: com blocos `moved` no código, em vez de `tofu state mv`. Compare as duas
abordagens:

- Qual delas fica registrada no Git?
- Qual acontece na hora, e qual só acontece no próximo `apply`?
