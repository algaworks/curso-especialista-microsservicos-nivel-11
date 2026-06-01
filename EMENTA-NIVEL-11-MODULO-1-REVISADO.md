# Módulo 1: Fundamentos de Cloud Computing — Proposta Revisada

> **Base:** `EMENTA-NIVEL-11-AWS.md` (Módulo 1 original com 26 aulas)
> **Objetivo desta revisão:** reordenar para fluxo pedagógico mais natural, eliminar duplicação com Módulos 2 e 5, e mover compute primitives + orchestration patterns + resilience concepts pareados (Failover, Self Healing) para o Módulo 5.

## Resumo das mudanças

1. **Removidas do Módulo 1:** 01.14 (Conceitos básicos de rede) e 01.15 (Latência, edge locations) — ambos já cobertos pelo Módulo 2.
2. **Movidas para abertura do Módulo 5:** VMs (01.18), Containers (01.19), Containers vs VMs (01.20), CNCF (01.16, 01.17) e Service Instance Patterns (01.21, 01.22, 01.23).
3. **Movidas para o corpo do Módulo 5 (pareadas com sua implementação):**
   - **01.11 Failover e Fault Tolerance** → antes de **5.07 ReplicaSet** (ReplicaSet é a primitiva de failover do K8s)
   - **01.12 Self Healing** → antes de **5.27 Probes** (Readiness/Liveness implementam self-healing)
4. **Pricing desce** após apresentação dos providers.
5. **Renomeação de 01.21–01.23 + 5.14, 5.15** para diferenciar conceito (teoria) de implementação (prática no K8s).
6. **Estudo de caso final vira Desafio prático.**
7. **Sugestão opcional:** mover bloco de decisão (quando migrar / desafio) para fechamento do curso, após Módulo 8.

> ℹ️ **Nota pedagógica:** ao chegar no Módulo 2, quando EC2 aparecer, basta um disclaimer rápido — *"EC2 é o serviço de VM da AWS; o que é VM e quando usar versus container vamos aprofundar no Módulo 5"*. Não compromete o fluxo.

---

## Nova ordem do Módulo 1 (13 aulas)

| # | Título | Origem | Notas |
|---|---|---|---|
| 1.01 | Introdução ao curso e visão geral do projeto | = 01.01 | — |
| 1.02 | O que é Cloud Computing: definição e evolução | = 01.02 | — |
| 1.03 | Cloud vs On-Premise: quando usar cada abordagem | = 01.03 | — |
| 1.04 | Fundamentos de Cloud Computing (IaaS, PaaS, SaaS) | = 01.04 | — |
| 1.05 | Características essenciais: elasticidade, escalabilidade e self-service | = 01.05 | — |
| 1.06 | Principais Cloud Providers e comparação (AWS, Azure, GCP) | era 01.07 | Subiu — fecha bloco "o que é cloud" |
| 1.07 | Modelos de precificação: Pay-as-you-go, Reserved, Spot | era 01.06 | Desceu — após conhecer providers |
| 1.08 | Shared Responsibility Model: segurança compartilhada | = 01.08 | Ponte para o resto |
| 1.09 | Conceitos de disponibilidade e SLA: calculando uptime (99.9%–99.999%) | era 01.09 | — |
| 1.10 | Durabilidade vs Disponibilidade: entendendo diferenças críticas | = 01.10 | — |
| 1.11 | Backup e Disaster Recovery: conceitos RTO e RPO | era 01.13 | Mantido — propriedade operacional fundamental |
| 1.12 | Casos de uso: quando migrar (e quando NÃO migrar) para cloud | = 01.24 + 01.25 | Consolidação sugerida |
| 1.13 | 🎯 **Desafio:** desenhar arquitetura on-premise vs cloud para um cenário proposto | era 01.26 | Único momento prático do módulo |

**Total:** 13 aulas (12 teóricas + 1 desafio prático).

> Se preferir manter 01.24 e 01.25 separadas (como no original), o módulo fica com 14 aulas.

---

## Abertura proposta do Módulo 5 (8 aulas novas antes do 5.01)

Bridge narrativo completo: **máquina física → VM → container → orquestração → Kubernetes**.

| # sugerido | Título | Origem | Função |
|---|---|---|---|
| 5.00a | Máquinas virtuais: conceitos e casos de uso | era 01.18 | Compute primitive #1 |
| 5.00b | Containers: conceitos fundamentais | era 01.19 | Compute primitive #2 |
| 5.00c | Containers vs VMs: vantagens e desvantagens | era 01.20 | Trade-off entre os dois |
| 5.00d | O que é Cloud Native (definição CNCF) | era 01.16 | Posiciona o universo onde K8s vive |
| 5.00e | Ecossistema CNCF: panorama de projetos e categorias | era 01.17 | Mapa (K8s, Argo, Helm, Prometheus...) |
| 5.00f | Multiple Service Instance per Host: conceito e trade-offs | era 01.21 | Início da argumentação dos patterns |
| 5.00g | Service Instance per VM: conceito e trade-offs | era 01.22 | Evolução |
| 5.00h | Service Instance per Container: conceito → "por isso K8s" | era 01.23 | **Payoff:** justifica a chegada do Kubernetes |
| 5.01 | Kubernetes: arquitetura e conceitos fundamentais | (existente) | Continua daqui |

---

## Conceitos de resiliência pareados no corpo do Módulo 5

Em vez de ensinar resiliência abstratamente no Módulo 1, os conceitos entram **logo antes** de sua implementação concreta no K8s:

| Posição sugerida | Título | Origem | Por que aqui |
|---|---|---|---|
| Antes de **5.07 ReplicaSet** | **Failover e Fault Tolerance: garantindo resiliência** | era 01.11 | ReplicaSet **é** a primitiva de failover do K8s — "garanta N pods; se um morrer, crie outro". Conceito → implementação imediata. |
| Antes de **5.27 Probes** | **Self Healing: recuperação automática de falhas** | era 01.12 | Readiness/Liveness/Startup Probes são o mecanismo de self-healing. ArgoCD Self Healing (6.23) reaproveita o vocabulário depois. |

**Sequência resultante no Módulo 5:**
```
5.00a–h  Abertura conceitual
5.01     K8s arquitetura
5.02     Control Plane vs Worker Nodes
5.03     Instalando kubectl/Kind
5.04     Cluster local
5.05     Pods
5.06     Multi-container Pods
[NOVO]   Failover e Fault Tolerance (era 01.11)
5.07     ReplicaSet (implementa failover)
5.08     Deployments
...
5.26     Path/Host-based routing
[NOVO]   Self Healing (era 01.12)
5.27     Probes (implementam self-healing)
...
```

---

## Renomeações no Módulo 5 (para consistência)

| Aula | Nome atual | Renomeação sugerida |
|---|---|---|
| 5.14 | Service Instance per Container Pattern | **Aplicando Service Instance per Container com Pods** |
| 5.15 | Service Deployment Platform Pattern | **Service Deployment Platform com Deployments** |

---

## Sugestão opcional: mover bloco de decisão para o fim do curso

As aulas **1.12–1.13 (quando migrar / desafio)** poderiam ser movidas para **depois do Módulo 8** (ou no Módulo 9 - Apêndice):

1. Após viver o AlgaDelivery na AWS, a discussão "quando migrar" fica muito mais rica.
2. Reduz o Módulo 1 de 13 para 11 aulas.

**Trade-off:** quebra a expectativa de "Módulo 1 = visão completa de cloud".

---

## Lacunas conhecidas (NÃO tratadas aqui)

- **Observabilidade:** será tratada ao final do curso, após o deploy do Algashop (decisão do instrutor).
- **IAM:** será introduzido pontualmente nos Módulos 5/8 conforme necessário (decisão do instrutor).
- **FinOps avançado:** não previsto.

---

## Diff resumido (ordem original → nova)

```
Original Módulo 1: 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26

Removidas:           14, 15
Movidas → M5 abre:   16, 17, 18, 19, 20, 21, 22, 23
Movidas → M5 corpo:  11 (antes de 5.07), 12 (antes de 5.27)
Mantida no M1:       13 (Backup/DR/RTO/RPO)
Desafio prático:     26 vira "Desafio"

Novo Módulo 1: 01 02 03 04 05 07 06 08 09 10 13 24 25/26[DESAFIO]
Novo M5 abre:  18 19 20 16 17 21 22 23  → 5.01 ...
Novo M5 corpo: ... 5.06 [11] 5.07 ... 5.26 [12] 5.27 ...
```
