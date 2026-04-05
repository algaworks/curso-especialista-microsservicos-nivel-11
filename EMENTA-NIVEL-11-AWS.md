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

### ☁️ **Módulo 1: Fundamentos de Cloud Computing**


| **Aula** | **Título** | **Tipo** |
|----------|------------|----------|
| 01.01. Introdução ao curso e visão geral do projeto 
| 01.02. O que é Cloud Computing: definição e evolução 
| 01.03. Cloud vs On-Premise: quando usar cada abordagem 
| 01.04. Fundamentos de Cloud Computing (IaaS, PaaS, SaaS) 
| 01.05. Características essenciais: elasticidade, escalabilidade e self-service 
| 01.06. Modelos de precificação: Pay-as-you-go, Reserved, Spot 
| 01.07. Principais Cloud Providers e comparação (AWS, Azure, GCP) 
| 01.08. Shared Responsibility Model: segurança compartilhada 
| 01.09. Conceitos de disponibilidade e SLA: calculando uptime (99.9%, 99.99%, 99.999%) 
| 01.10. Durabilidade vs Disponibilidade: entendendo diferenças críticas 
| 01.11. Failover e Fault Tolerance: garantindo resiliência 
| 01.12. Self Healing: recuperação automática de falhas 
| 01.13. Backup e Disaster Recovery: conceitos RTO e RPO 
| 01.14. Conceitos básicos de rede em cloud (IP público/privado, DNS) 
| 01.15. Latência, proximidade e edge locations 
| 01.16. O que é Cloud Native (definição CNCF) 
| 01.17. Ecossistema CNCF: panorama de projetos e categorias
| 01.18. Máquinas virtuais: conceitos e casos de uso 
| 01.19. Containers: conceitos fundamentais 
| 01.20. Containers vs VMs: vantagens e desvantagens
| 01.21. Multiple Service Instance per Host Pattern 
| 01.22. Service Instance per VM Pattern 
| 01.23. Service Instance per Container Pattern 
| 01.24. Casos de uso: quando migrar para cloud 
| 01.25. Casos de uso: quando NÃO migrar para cloud 
| 01.26. Exemplo prático: arquitetura on-premise vs cloud 


---

### 🏗️ **Módulo 2: Fundamentos de Redes na AWS**


| **Aula** | **Título** | **Tipo** |
|----------|------------|----------|
| 2.01. Visão geral da infraestrutura global da AWS
| 2.02. Criando sua conta na Amazon AWS
| 2.03. Criando alerta de billing para controle de custos
| 2.04. Regiões e Zonas de Disponibilidades
| 2.05. Arquiteturas Single-AZ vs Multi-AZ 
| 2.06. Analisando desenho de Infra do AlgaDelivery 
| 2.07. O que é uma VPC 
| 2.08. Entendendo um pouco mais sobre CIDR
| 2.09. Planejamento de Subnets e cálculo de CIDR 
| 2.10. Criando sua primeira VPC na AWS 
| 2.11. Subnets públicas e privadas 
| 2.12. Tabelas de roteamento 
| 2.13. Internet Gateway 
| 2.14. NAT Gateway 
| 2.15. Elastic IP (EIP) 
| 2.16. Elastic Network Interfaces (ENI) 
| 2.17. Entendendo Firewall Stateful vs Stateless 
| 2.18. Security Groups 
| 2.19. Network ACLs 
| 2.20. Criando instância EC2 pública na VPC 
| 2.21. Criando instância EC2 privada na VPC 
| 2.22. Acessando recursos privados com Bastion Host 
| 2.23. Introdução ao DNS e Route 53 
| 2.24. Configurando registros DNS básicos no Route 53 


---

### 🏗️ **Módulo 3: Dominando Infra as Code com OpenTofu**

| **Aula** | **Título** | **Tipo** |
|----------|------------|----------|
| 3.01. Infrastructure as Code: benefícios e práticas 
| 3.02. Terraform vs OpenTofu: o que usar 
| 3.03. Instalando e configurando OpenTofu 
| 3.04. Comandos essenciais do OpenTofu CLI 
| 3.05. Providers: configuração e versionamento 
| 3.06. Tipos de dados e type constraints 
| 3.07. Criando um S3 Bucket com OpenTofu 
| 3.08. Alterando e destruindo recursos 
| 3.09. Trabalhando com variáveis e validações 
| 3.10. Locals e outputs 
| 3.11. Explorando o arquivo tfstate 
| 3.12. Configurando backend remoto com S3 
| 3.13. Dependências: implícitas vs explícitas 
| 3.14. Lifecycle rules e meta-arguments 
| 3.15. Built-in functions 
| 3.16. Conditional expressions 
| 3.17. Data Sources 
| 3.18. Count: criando múltiplos recursos 
| 3.19. For_each: iteração avançada
| 3.20. Dynamic blocks 
| 3.21. Trabalhando com dados sensíveis 
| 3.22. Gerenciamento avançado de state 
| 3.23. Importando recursos existentes 
| 3.24. Módulos: criando e reutilizando 
| 3.25. Workspaces: gerenciando ambientes 
| 3.26. Debugging e troubleshooting 
| 3.27. Null Resource e Provisioners

---

### 🏗️ **Módulo 4: Provisionando Networking e Services com OpenTofu**


| **Aula** | **Título** | **Tipo** |
|----------|------------|----------|
| 4.01. Arquitetura da infraestrutura do AlgaDelivery 
| 4.02. Estimando custos da infraestrutura com AWS Pricing Calculator 
| 4.03. Estruturando projeto OpenTofu multi-ambiente 
| 4.04. Criando módulo VPC com terraform-aws-modules 
| 4.05. Configurando subnets públicas e privadas com OpenTofu 
| 4.06. Provisionando IGW e NAT Gateway com OpenTofu 
| 4.07. Security Groups com OpenTofu
| 4.08. Network ACLs com OpenTofu 
| 4.09. Remote state: compartilhando dados entre módulos 
| 4.10. Introdução ao RDS e parameter groups 
| 4.11. Provisionando RDS PostgreSQL via AWS Console 
| 4.12. Provisionando RDS PostgreSQL via OpenTofu 
| 4.13. Bastion Host: acesso seguro a recursos privados 
| 4.14. Testando conexão ao RDS via Bastion Host
| 4.15. Introdução ao ElastiCache Redis/Valkey 
| 4.16. Provisionando ElastiCache Valkey via AWS Console 
| 4.17. Provisionando ElastiCache Valkey via OpenTofu 
| 4.18. Introdução ao Amazon MSK (Kafka) 
| 4.19. Provisionando Amazon MSK via AWS Console 
| 4.20. Provisionando Amazon MSK via OpenTofu

---

### 🐳 **Módulo 5: Dominando orquestração de containers com Kubernetes**

| **Aula** | **Título** | **Tipo** |
|----------|------------|----------|
| 5.01. Kubernetes: arquitetura e conceitos fundamentais,5.02. Control Plane vs Worker Nodes 
| 5.03. Instalando kubectl, Kind e ferramentas essenciais 
| 5.04. Criando e explorando cluster local com Kind 
| 5.05. Pods: conceitos, ciclo de vida e criação 
| 5.06. Multi-container Pods e comunicação 
| 5.07. ReplicaSet: garantindo disponibilidade de Pods 
| 5.08. Deployments: criando e versionando aplicações 
| 5.09. Estratégias de deployment: Rolling Update vs Recreate 
| 5.10. Rollback e histórico de Deployments 
| 5.11. StatefulSets: gerenciando workloads com estado 
| 5.12. DaemonSets: executando pod em cada node 
| 5.13. Jobs e CronJobs: tarefas pontuais e agendadas 
| 5.14. Service Instance per Container Pattern
| 5.15. Service Deployment Platform Pattern
| 5.16. Sidecar Pattern na prática
| 5.17. ConfigMaps: externalizando configurações 
| 5.18. Secrets: gerenciando dados sensíveis 
| 5.19. Namespaces: organizando e isolando recursos
| 5.20. Labels, Selectors e Annotations 
| 5.21. Services: conceitos e ClusterIP 
| 5.22. NodePort: expondo serviços externamente 
| 5.23. Headless Services para StatefulSets 
| 5.24. Service Discovery e DNS interno
| 5.25. Ingress: conceitos e instalação do NGINX Controller 
| 5.26. Path-based e Host-based routing com Ingress 
| 5.27. Readiness, Liveness e Startup Probes 
| 5.28. Resource Requests e Limits: gerenciando recursos 
| 5.29. QoS Classes: Guaranteed, Burstable e BestEffort 
| 5.30. Metrics Server e métricas para autoscaling 
| 5.31. Horizontal Pod Autoscaler (HPA): conceitos e configuração 
| 5.32. Node Selector: scheduling básico de Pods 
| 5.33. Node Affinity e Anti-Affinity 
| 5.34. Pod Affinity e Anti-Affinity 
| 5.35. Taints e Tolerations: controlando scheduling 
| 5.36. Persistent Volumes e Persistent Volume Claims 
| 5.37. Storage Classes e provisionamento dinâmico 
| 5.38. Service Accounts: identidade para Pods 
| 5.39. RBAC: Roles e RoleBindings 
| 5.40. RBAC: ClusterRoles e ClusterRoleBindings
| 5.41. Kubectl Port-forward e Proxy
| 5.43. Conhecendo o Rancher 
| 5.42. Conhecendo a Lens IDE para K8s 

---

### 🚀 **Módulo 6: Ferramentas de Deploy e GitOps**


| **Aula** | **Título** | **Tipo** |
|----------|------------|----------|
| 6.01. Relembrando Continuous Deployment vs Continuous Delivery 
| 6.02. Desafios de gerenciamento de manifestos em Kubernetes
| 6.03. Kustomize: conceitos e estrutura (bases e overlays) 
| 6.04. Kustomize: patches, transformers e generators 
| 6.05. Gerenciando múltiplos ambientes com Kustomize 
| 6.06. Helm: conceitos e instalação 
| 6.07. Anatomia de um Helm Chart 
| 6.08. Gerenciando releases: install, upgrade e rollback 
| 6.09. API Gateway: conceitos e uso com Kubernetes 
| 6.10. Instalando Kong Gateway com Helm 
| 6.11. Configurando rotas no Kong 
| 6.12. Explorando plugins com Kong 
| 6.13. Criando Helm Chart customizado
| 6.14. Templates, values e funções do Helm 
| 6.15. Helm repositories e versionamento de charts 
| 6.16. GitOps: princípios e benefícios 
| 6.17. ArgoCD: visão geral e arquitetura 
| 6.18. Configurando ArgoCD no Kubernetes
| 6.19. Cadastrando repositórios Git no ArgoCD
| 6.20. Criando Applications no ArgoCD
| 6.21. ArgoCD Sync manual vs automático
| 6.22. Rollback automatizado com ArgoCD
| 6.23. ArgoCD Self Healing
| 6.24. Continuous Deployment na prática com GitLab e ArgoCD
| 6.25. Apêndice: Argo Rollouts para deployments avançados

---

### 🔐 **Módulo 7: Configuração Externalizada e Gestão de Segredos**


| **Aula** | **Título** | **Tipo** |
|----------|------------|----------|
| 7.01. Externalized Configuration Pattern 
| 7.02. 12-Factor App: Config na cloud 
| 7.03. AWS Parameter Store: conceitos e uso 
| 7.04. Armazenando configurações no Parameter Store 
| 7.05. AWS Secrets Manager: gestão de credenciais 
| 7.06. Rotação automática de senhas 
| 7.07. Spring Cloud for AWS: integração 
| 7.08. Lendo configurações do Parameter Store com Spring 
| 7.09. Lendo secrets do Secrets Manager com Spring 
| 7.10. Reload de configurações sem redeploy

---

### 🚀 **Módulo 8: Deploy Completo do AlgaDelivery na AWS**


| **Aula** | **Título** | **Tipo** |
|----------|------------|----------|
| 8.01. Arquitetura final do AlgaDelivery na AWS 
| 8.02. Provisionando cluster EKS via AWS Console 
| 8.03. Provisionando cluster EKS com OpenTofu 
| 8.04. Configurando node groups via AWS Console 
| 8.05. Configurando node groups e capacity com OpenTofu 
| 8.06. EKS Add-ons via AWS Console 
| 8.07. Provisionando EKS Add-ons com OpenTofu 
| 8.08. EBS CSI Driver via AWS Console 
| 8.09. Provisionando EBS CSI Driver com OpenTofu 
| 8.10. NGINX Ingress Controller via OpenTofu
| 8.11. Service do tipo LoadBalancer com NLB 
| 8.12. Cloudflare: criando conta e conceitos fundamentais 
| 8.13. Configurando nameservers do Cloudflare 
| 8.14. Criando DNS com Ingress para acesso a recursos do cluster 
| 8.15. AWS Certificate Manager (ACM): gerenciando certificados 
| 8.16. Solicitando certificados SSL/TLS via AWS Console 
| 8.17. Gerenciando certificados ACM com OpenTofu 
| 8.18. Configurando HTTPS no Ingress com ACM 
| 8.19. Estratégia de API Gateway para AlgaDelivery 
| 8.20. Instalando Kong no EKS com OpenTofu 
| 8.21. Configurando Kong com Service LoadBalancer 
| 8.22. Criando rotas para os microserviços no Kong 
| 8.23. Utilizando Plugins no ingress do Kong
| 8.24. Externalizando configurações do AlgaDelivery com Parameter Store
| 8.25. Criando Helm Charts do AlgaDelivery 
| 8.26. Templates e values para múltiplos ambientes 
| 8.27. Instalando ArgoCD no EKS com OpenTofu 
| 8.28. Configurando AlgaDelivery no ArgoCD
| 8.29. Pipeline completa: build, push, deploy via GitOps
| 8.30. Testando aplicação em produção na AWS
| 8.31. Provisionando o Rancher via OpenTofu
| 8.32. Conclusão e próximos passos


### 🚀 **Módulo 9: Apêndice - Deploy Algashop**