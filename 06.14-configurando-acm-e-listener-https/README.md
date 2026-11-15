# 6.12 · Configurando o domínio do AlgaDelivery

O código OpenTofu é o mesmo da `06.11-aws-lb-controller-helm`. A novidade desta aula está em `k8s/`:
duas aplicações atrás de um único ALB, prontas para receber o domínio de verdade.

| Arquivo | O que faz |
|---|---|
| `k8s/apps.yaml` | Deployments + Services `hellojava` e `rastreio` (mesma imagem `whoami`) |
| `k8s/ingress-host.yaml` | roteamento por **host**: `hellojava.algashop.com.br` e `rastreio.algashop.com.br` |
| `k8s/ingress-path.yaml` | roteamento por **caminho** (`/hello`, `/rastreio`), no mesmo ALB (`group.name: algashop`) |

> O domínio está escrito em `ingress-host.yaml`. Se o seu for outro, troque nas duas regras `host:`.

## 1 · Subir a infra e os apps

```bash
cp example.tfvars dev.tfvars    # o dev.tfvars fica fora do Git: crie o seu a partir do modelo
                                # e troque o cloudflare_zone_id pelo da sua zona
read -s TF_VAR_cloudflare_api_token && export TF_VAR_cloudflare_api_token
tofu init -reconfigure -var-file=dev.tfvars
tofu apply -var-file=dev.tfvars

aws eks update-kubeconfig --name development-algadelivery-cluster --region us-east-1
kubectl apply -f k8s/apps.yaml -f k8s/ingress-host.yaml -f k8s/ingress-path.yaml
kubectl get ingress        # espere o ADDRESS aparecer (1-2 min)
```

## 2 · Antes do DNS: o host ainda é fingido

```bash
ALB=$(kubectl get ingress algashop-host -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
curl -H "Host: hellojava.algashop.com.br" http://$ALB
curl -H "Host: rastreio.algashop.com.br"  http://$ALB
```

## 3 · Na Cloudflare: os records (DNS only, nuvem cinza)

| Type | Name | Target |
|---|---|---|
| CNAME | `hellojava` | `$ALB` |
| CNAME | `rastreio` | `$ALB` |

Crie os records **antes** de trocar os NS no Registro.br, para ver a diferença:

```bash
dig hellojava.algashop.com.br +short                          # nada: o mundo ainda pergunta ao Registro.br
dig hellojava.algashop.com.br @<ns>.ns.cloudflare.com +short  # a Cloudflare já sabe

# troca os NS no Registro.br e espera alguns minutos
dig NS algashop.com.br +short                                 # os NS da Cloudflare
dig hellojava.algashop.com.br +short                          # agora resolve para o ALB
```

## 4 · O teste final, sem truque

```bash
curl http://hellojava.algashop.com.br    # Name: hellojava · Host: hellojava.algashop.com.br
curl http://rastreio.algashop.com.br     # Name: rastreio  · outro Pod, mesmo ALB
```

No navegador, digite `http://` explicitamente. Ainda não há listener 443 nem certificado: o HTTPS é a próxima aula.

## 5 · Destroy (o ALB não está no state)

```bash
kubectl delete ingress --all -A     # espere o ALB sumir no Console
tofu destroy -var-file=dev.tfvars
```
