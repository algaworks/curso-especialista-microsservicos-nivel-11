# Ementa do Curso: Microsserviços em Produção na AWS (Nível 11)

## 🎯 **Objetivo Geral:**
Capacitar profissionais para implementar e gerenciar microserviços em produção na AWS, utilizando Kubernetes (EKS), Terraform para IaC, e práticas avançadas de deployment, escalabilidade, segurança e observabilidade. O curso utiliza o projeto AlgaDelivery como base prática, evoluindo a pipeline GitLab CI/CD do Nível 9 para deploy automatizado na AWS.

## 📋 **Pré-requisitos:**
- ✅ Conclusão do Nível 9 (Práticas Avançadas de DevOps)
- ✅ Conhecimento em Docker e containerização
- ✅ Familiaridade com GitLab CI/CD e pipelines
- ✅ Conhecimentos básicos de redes e Linux

---

## 📊 **ESTRUTURA DO CURSO:**

### ☁️ **Módulo 1: Fundamentos de Cloud Computing** — 🎥 _em gravação_


| **Aula** | **Título** | **Tipo** |
|----------|------------|----------|
| 01.01. Introdução ao curso e visão geral do projeto 
| 01.02. O que é Cloud Computing: definição e evolução 
| 01.03. Cloud vs On-Premise: quando usar cada abordagem 
| 01.04. Fundamentos de Cloud Computing (IaaS, PaaS, SaaS) 
| 01.05. Características essenciais: elasticidade, escalabilidade e self-service 
| 01.06. Principais Cloud Providers e comparação (AWS, Azure, GCP) 
| 01.07. Modelos de precificação: Pay-as-you-go, Reserved, Spot 
| 01.08. Shared Responsibility Model: segurança compartilhada 
| 01.09. Conceitos de disponibilidade e SLA: calculando uptime (99.9%, 99.99%, 99.999%) 
| 01.10. Durabilidade vs Disponibilidade: entendendo diferenças críticas 
| 01.11. Backup e Disaster Recovery: conceitos RTO e RPO 
| 01.12. Casos de uso: quando migrar (e quando NÃO migrar) para cloud 
| 01.13. Desafio: desenhar arquitetura on-premise vs cloud para um cenário proposto 


---

### 🏗️ **Módulo 2: Fundamentos de Redes na AWS** — ✅ _finalizado_


| **Aula** | **Título** | **Tipo** |
|----------|------------|----------|
| 2.01. Visão geral da rede do AlgaDelivery na AWS 
| 2.02. Criando sua conta na Amazon AWS 
| 2.03. Criando budgets para controle de custo 
| 2.04. Regiões e AZs (Zonas de Disponibilidades) 
| 2.05. VPC: Fundamentos da Rede Virtual na AWS 
| 2.06. CIDR Blocks e Planejamento de Endereçamento IP 
| 2.07. Criando uma VPC na AWS 
| 2.08. Subnets: Segmentação da VPC 
| 2.09. Criando Subnets na AWS 
| 2.10. Route Tables e Decisão de Tráfego 
| 2.11. Criando Route tables na AWS 
| 2.12. Internet Gateway: Conectando a VPC à Internet 
| 2.13. Criando Internet Gateway na AWS 
| 2.14. NAT Gateway: Saída Segura para Subnets Privadas 
| 2.15. Criando NAT Gateway na AWS 
| 2.16. Security Groups: Firewall de recursos 
| 2.17. Provisionando uma EC2 Pública na VPC 
| 2.18. Criando um Elastic IP em uma EC2 
| 2.19. Provisionando uma EC2 Privada 


---

### 🏗️ **Módulo 3: Infraestrutura como Código (IaC) na AWS** — ✅ _finalizado_

| **Aula** | **Título** | **Tipo** |
|----------|------------|----------|
| 3.01. Introdução ao IaC 
| 3.02. Explorando o Terraform e OpenTofu 
| 3.03. Setup do ambiente (OpenTofu + AWS CLI) 
| 3.04. Configurando um Provider 
| 3.05. Criando o primeiro recurso com OpenTofu 
| 3.06. Fluxo de trabalho com OpenTofu 
| 3.07. Trabalhando com variáveis 
| 3.08. Gerando Outputs 
| 3.09. Explorando o arquivo tfstate 
| 3.10. Backend remoto com S3 
| 3.11. Criando uma VPC com OpenTofu 
| 3.12. Criando subnets públicas com OpenTofu 
| 3.13. Utilizando expressions e meta-arguments 
| 3.14. Criando Internet Gateway com OpenTofu 
| 3.15. Criando subnets privadas e Nat Gateway com OpenTofu 
| 3.16. Configurando Route tables com OpenTofu 
| 3.17. Criando Security Groups (Bastion + Private) 
| 3.18. Utilizando Data Sources e Functions 
| 3.19. Criando EC2 com OpenTofu 
| 3.20. Testando conectividade da rede 
| 3.21. Destruindo os recursos com OpenTofu 

---

### 🏗️ **Módulo 4: IaC Modular e Serviços Gerenciados na AWS** — ✅ _finalizado_


| **Aula** | **Título** | **Tipo** |
|----------|------------|----------|
| 4.01. Introdução ao módulo 
| 4.02. Utilizando dynamics blocks 
| 4.03. Criando modulo VPC 
| 4.04. Tipos de coleções e for expressions 
| 4.05. Refatorando o módulo VPC 
| 4.06. Criando modulo EC2 
| 4.07. Explorando multi-env no OpenTofu 
| 4.08. Lifecycle e boas práticas no OpenTofu 
| 4.09. Criando um RDS PostgreSQL via Console 
| 4.10. Provisionando RDS PostgreSQL via OpenTofu 
| 4.11. Gerenciando senhas com segurança no RDS 
| 4.12. Criando modulo RDS 
| 4.13. Configurando backup e janela de manutenção no RDS 
| 4.14. Criando um ElastiCache Valkey via Console 
| 4.15. Provisionando ElastiCache Valkey via OpenTofu 
| 4.16. Desafio: Criando Módulo ElastiCache 
| 4.17. Provisionando Amazon MSK (Kafka) via Console 
| 4.18. Provisionando Amazon MSK (Kafka) via OpenTofu 
| 4.19. Desafio: Modulo MSK 
| 4.20. Testando conectividade do banco RDS 
| 4.21. Destruindo os recursos 

---

### 🐳 **Módulo 5: Dominando orquestração de containers com Kubernetes** — 📋 _ementa planejada_

| **Aula** | **Título** | **Tipo** |
|----------|------------|----------|
| 5.01. Máquinas virtuais: conceitos e casos de uso 
| 5.02. Containers: conceitos fundamentais 
| 5.03. Containers vs VMs: vantagens e desvantagens 
| 5.04. Cloud Native e ecossistema CNCF 
| 5.05. Multiple Service Instance per Host: conceito e trade-offs 
| 5.06. Service Instance per VM: conceito e trade-offs 
| 5.07. Service Instance per Container: conceito e trade-offs 
| 5.08. Kubernetes: arquitetura, Control Plane e Worker Nodes 
| 5.09. Instalando kubectl, Kind e criando cluster local 
| 5.10. Pods: conceitos, ciclo de vida e criação 
| 5.11. Multi-container Pods e comunicação 
| 5.12. Failover e Fault Tolerance: garantindo resiliência 
| 5.13. ReplicaSet: garantindo disponibilidade de Pods 
| 5.14. Deployments: criando e versionando aplicações 
| 5.15. Estratégias de deployment: Rolling Update, Recreate e Rollback 
| 5.16. StatefulSets: gerenciando workloads com estado 
| 5.17. DaemonSets: executando pod em cada node 
| 5.18. Jobs e CronJobs: tarefas pontuais e agendadas 
| 5.19. Aplicando Service Instance per Container com Pods 
| 5.20. Service Deployment Platform com Deployments 
| 5.21. Sidecar Pattern na prática 
| 5.22. ConfigMaps e Secrets: externalizando configurações e credenciais 
| 5.23. Namespaces: organizando e isolando recursos 
| 5.24. Labels, Selectors e Annotations 
| 5.25. Services: conceitos e ClusterIP 
| 5.26. NodePort: expondo serviços externamente 
| 5.27. Headless Services para StatefulSets 
| 5.28. Service Discovery e DNS interno 
| 5.29. Ingress: NGINX Controller com Path-based e Host-based routing 
| 5.30. Self Healing com Readiness, Liveness e Startup Probes 
| 5.31. Resource Requests, Limits e QoS Classes 
| 5.32. Metrics Server e HPA: autoscaling de Pods 
| 5.33. Node Selector: scheduling básico de Pods 
| 5.34. Node Affinity e Anti-Affinity 
| 5.35. Pod Affinity e Anti-Affinity 
| 5.36. Taints e Tolerations: controlando scheduling 
| 5.37. Persistent Volumes, PVC e Storage Classes 
| 5.38. Service Accounts: identidade para Pods 
| 5.39. RBAC: Roles, ClusterRoles e Bindings 
| 5.40. Kubectl Port-forward e Proxy 
| 5.41. Ferramentas de gestão: Rancher e Lens IDE 

---

### 🚀 **Módulo 6: Provisionando o cluster EKS na AWS com OpenTofu** — 📋 _ementa planejada_


| **Aula** | **Título** | **Tipo** |
|----------|------------|----------|
| 6.01. EKS: arquitetura, componentes e modelo gerenciado 
| 6.02. Provisionando cluster EKS via AWS Console 
| 6.03. Provisionando cluster EKS com OpenTofu 
| 6.04. Configurando node groups via AWS Console 
| 6.05. Configurando node groups e capacity com OpenTofu 
| 6.06. EKS Add-ons via AWS Console 
| 6.07. Provisionando EKS Add-ons com OpenTofu 
| 6.08. EBS CSI Driver via AWS Console 
| 6.09. Provisionando EBS CSI Driver com OpenTofu 
| 6.10. NGINX Ingress Controller via OpenTofu 
| 6.11. Service do tipo LoadBalancer com NLB 
| 6.12. Cloudflare: criando conta e conceitos fundamentais 
| 6.13. Configurando nameservers do Cloudflare 
| 6.14. Criando DNS com Ingress para acesso a recursos do cluster 
| 6.15. AWS Certificate Manager (ACM): gerenciando certificados 
| 6.16. Solicitando certificados SSL/TLS via AWS Console 
| 6.17. Gerenciando certificados ACM com OpenTofu 
| 6.18. Configurando HTTPS no Ingress com ACM 
| 6.19. Provisionando Kong API Gateway no EKS com OpenTofu e Service LoadBalancer 
| 6.20. Provisionando o Rancher via OpenTofu 

---

### 🚀 **Módulo 7: Ferramentas de Deploy e GitOps** — 📋 _ementa planejada_


| **Aula** | **Título** | **Tipo** |
|----------|------------|----------|
| 7.01. Relembrando Continuous Deployment vs Continuous Delivery 
| 7.02. Desafios de gerenciamento de manifestos em Kubernetes
| 7.03. Kustomize: conceitos e estrutura (bases e overlays) 
| 7.04. Kustomize: patches, transformers e generators 
| 7.05. Gerenciando múltiplos ambientes com Kustomize 
| 7.06. Helm: conceitos e instalação 
| 7.07. Anatomia de um Helm Chart 
| 7.08. Gerenciando releases: install, upgrade e rollback 
| 7.09. API Gateway: conceitos e uso com Kubernetes 
| 7.10. Instalando Kong Gateway com Helm provider no OpenTofu 
| 7.11. Configurando rotas no Kong 
| 7.12. Explorando plugins com Kong 
| 7.13. Criando Helm Chart customizado
| 7.14. Templates, values e funções do Helm 
| 7.15. Helm repositories e versionamento de charts 
| 7.16. GitOps: princípios e benefícios 
| 7.17. ArgoCD: visão geral e arquitetura 
| 7.18. Instalando ArgoCD via Helm provider no OpenTofu
| 7.19. Cadastrando repositórios Git no ArgoCD
| 7.20. Criando Applications no ArgoCD
| 7.21. ArgoCD Sync manual vs automático
| 7.22. Rollback automatizado com ArgoCD
| 7.23. ArgoCD Self Healing
| 7.24. Continuous Deployment na prática com GitLab e ArgoCD
| 7.25. Apêndice: Argo Rollouts via Helm provider no OpenTofu para deployments avançados

---

### 🔐 **Módulo 8: Configuração Externalizada e Gestão de Segredos** — 📋 _ementa planejada_


| **Aula** | **Título** | **Tipo** |
|----------|------------|----------|
| 8.01. Externalized Configuration Pattern 
| 8.02. 12-Factor App: Config na cloud 
| 8.03. AWS Parameter Store: conceitos e uso 
| 8.04. Armazenando configurações no Parameter Store 
| 8.05. AWS Secrets Manager: gestão de credenciais 
| 8.06. Rotação automática de senhas 
| 8.07. Spring Cloud for AWS: integração 
| 8.08. Lendo configurações do Parameter Store com Spring 
| 8.09. Lendo secrets do Secrets Manager com Spring 
| 8.10. Reload de configurações sem redeploy

---

### 🚀 **Módulo 9: Deploy Completo do AlgaDelivery na AWS** — 📋 _ementa planejada_


| **Aula** | **Título** | **Tipo** |
|----------|------------|----------|
| 9.01. Arquitetura final do AlgaDelivery na AWS 
| 9.02. Estratégia de API Gateway para AlgaDelivery 
| 9.03. Criando rotas para os microserviços no Kong 
| 9.04. Utilizando Plugins no ingress do Kong
| 9.05. Externalizando configurações do AlgaDelivery com Parameter Store
| 9.06. Criando Helm Charts do AlgaDelivery 
| 9.07. Templates e values para múltiplos ambientes 
| 9.08. Instalando ArgoCD no EKS com OpenTofu 
| 9.09. Configurando AlgaDelivery no ArgoCD
| 9.10. Pipeline completa: build, push, deploy via GitOps
| 9.11. Testando aplicação em produção na AWS
| 9.12. Conclusão e próximos passos


### 🚀 **Módulo 10: Apêndice - Deploy Algashop** — 📋 _ementa planejada_