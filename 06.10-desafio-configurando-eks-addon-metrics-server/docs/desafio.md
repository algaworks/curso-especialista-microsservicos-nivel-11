# Desafio 6.10 · Configurando o add-on Metrics Server no EKS

## Contexto

No Módulo 5 você configurou um HPA no Kind e viu que ele só funciona com o **Metrics Server** instalado. É ele
que coleta CPU e memória dos kubelets e publica esses números na API `metrics.k8s.io`. O HPA consulta essa API
a cada ~15 s para decidir se escala.

O cluster EKS que você montou até a 6.08 já tem `vpc-cni`, `kube-proxy`, `coredns` e o `aws-ebs-csi-driver`,
todos como **EKS add-ons** gerenciados pelo OpenTofu. **O Metrics Server não vem com o EKS.** Rode isto no
seu cluster:

```bash
kubectl top nodes
```

```
error: Metrics API not available
```

Sem ele, qualquer HPA que você subir fica com `TARGETS <unknown>/50%` e nunca escala.

> 💡 A AWS oferece o Metrics Server como **add-on da comunidade** (*community add-on*): a EKS empacota,
> testa e entrega a versão, mas o software é do projeto `kubernetes-sigs`, não da AWS. Na prática, ele se
> instala do mesmo jeito que os outros add-ons.

## O que você precisa fazer

Parta de uma cópia do código da 6.08.

### 1. Descubra o add-on

- Encontre o **nome exato** do add-on e as **versões compatíveis** com a versão do Kubernetes do seu cluster,
  pelo Console ou pela AWS CLI.
- Descubra quem é o *owner* desse add-on e compare com o dos add-ons que você já instalou.

### 2. Instale com OpenTofu

- Adicione o Metrics Server ao cluster **reaproveitando o que já existe** no código.
- Fixe a versão, como foi feito com o `vpc-cni`.
- Antes de escrever código, responda: o Metrics Server precisa de uma **role IRSA**, como o EBS CSI Driver
  precisou? Justifique pelo que ele faz.

### 3. Prove que funciona

- O add-on aparece como `ACTIVE`, tanto no Console quanto no `tofu state`.
- O Deployment do Metrics Server está rodando no namespace `kube-system`.
- A API de métricas está registrada e disponível no cluster.
- `kubectl top nodes` e `kubectl top pods -A` devolvem números.

### 4. *(Opcional)* Feche o ciclo com um HPA

- Suba o `k8s/whoami.yaml` e crie um HPA para ele, com alvo de **50% de CPU**, mínimo de 2 e máximo de 4
  réplicas.
- Confira que o `TARGETS` mostra um percentual de verdade, e não `<unknown>`.
- Explique: 50% **de quê**? Olhe o `resources` do `whoami.yaml`.

## Critério de aceite

- [ ] `tofu fmt -check -recursive` não aponta arquivos para formatar
- [ ] `tofu validate` responde `Success`
- [ ] `tofu plan -var-file=dev.tfvars` mostra **só** o add-on novo sendo criado, sem mexer nos outros
- [ ] `tofu state list` mostra o add-on do Metrics Server
- [ ] `kubectl get apiservice v1beta1.metrics.k8s.io` responde `AVAILABLE   True`
- [ ] `kubectl top nodes` mostra CPU e memória de cada node
- [ ] *(opcional)* `kubectl get hpa` mostra um percentual em `TARGETS`, por exemplo `cpu: 2%/50%`

## Entregáveis

- o diff do código OpenTofu (o que você mudou em relação à 6.08)
- a saída do `kubectl top nodes`
- a resposta para a pergunta da IRSA, em uma ou duas frases
- *(opcional)* a saída do `kubectl get hpa` e a sua explicação do "50% de quê"

## Dicas (leia se travar)

<details>
<summary>Onde descobrir o nome e a versão do add-on?</summary>

No Console: **EKS → seu cluster → Add-ons → Get more add-ons**. Pela CLI:

```bash
aws eks describe-addon-versions --addon-name metrics-server --kubernetes-version <versao-do-cluster>
```

Repare nos campos `owner` e `defaultVersion`.
</details>

<details>
<summary>Preciso de um resource novo?</summary>

Olhe como o `vpc-cni`, o `kube-proxy` e o `coredns` foram instalados. Existe um `for_each` sobre um mapa de
add-ons. Se o Metrics Server não precisa de nada além de nome e versão, ele cabe ali.
</details>

<details>
<summary>Precisa de IRSA?</summary>

A IRSA existe para um Pod chamar uma **API da AWS**. O EBS CSI Driver precisa disso: ele cria e anexa volumes
EBS. Pergunte-se para onde o Metrics Server manda requisições: para a AWS, ou só para dentro do cluster?
</details>

<details>
<summary>Apliquei e o <code>kubectl top</code> ainda dá erro</summary>

O add-on leva alguns segundos para subir, e a primeira coleta leva mais uns 15 a 60 s. Confira, nesta ordem:
o status do add-on, o Pod em `kube-system` e a `APIService` `v1beta1.metrics.k8s.io`. Se a `APIService`
estiver `False`, o `kubectl describe` dela diz o motivo.
</details>

<details>
<summary>O HPA continua <code>&lt;unknown&gt;</code></summary>

Duas causas comuns: o Metrics Server ainda não coletou a primeira amostra (espere um minuto), ou o container
não declara `resources.requests.cpu`. Sem request, não existe base para calcular o percentual.
</details>

## Desafio extra (opcional)

O `vpc-cni` fixa a versão, mas o `kube-proxy` e o `coredns` não. O que acontece com um add-on **sem** versão
fixada:

- no primeiro `apply`?
- quando a AWS publicar uma versão default nova?
- quando você atualizar a versão do Kubernetes do cluster?

Qual das duas abordagens você usaria em produção, e por quê?
