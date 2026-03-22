# Curso: Infraestrutura como Código na AWS com OpenTofu

## 🎯 Visão do Curso
Construir uma infraestrutura real na AWS usando OpenTofu, com foco em código, organização e práticas de produção.

Arquitetura final:
S3 (state) → VPC → Subnets → IGW/NAT → Bastion → EC2 privada → Módulos → Multi-env

---

# 🔰 FASE 0 — CONTEXTO

## 00. Introdução + IaC + Benefícios
- Visão do que será construído
- Problema da infra manual
- Conceito de IaC
- Benefícios práticos

## 01. Terraform vs OpenTofu + Boas práticas
- Diferenças
- Por que OpenTofu
- Boas práticas:
  - Não alterar no console
  - Versionamento
  - Separação de ambientes
  - Uso de módulos

---

# 🔰 FASE 1 — BOOTSTRAP

## 02. Setup do ambiente
- Instalar OpenTofu
- Configurar AWS CLI

## 03. Primeiro recurso (S3)
- Criar bucket
- Executar apply

## 04. Fluxo básico
- plan / apply / destroy

## 05. Provider AWS
- Autenticação
- Região

---

# ⚙️ FASE 2 — ORGANIZAÇÃO

## 06. Variáveis
## 07. Outputs
## 08. Locals
## 09. Estrutura de projeto

```
main.tf
variables.tf
outputs.tf
```

---

# 🔐 FASE 3 — STATE

## 10. tfstate na prática
## 11. Backend remoto (S3 + DynamoDB)
## 12. Lock e conflitos

---

# 🌐 FASE 4 — REDE

## 13. VPC
## 14. Subnets públicas
## 15. Internet Gateway
## 16. Subnets privadas
## 17. NAT Gateway
## 18. Route tables
## 19. Associações
## 20. Refatoração com variáveis

---

# 🔐 FASE 5 — SEGURANÇA + COMPUTE

## 21. Security Groups
- Bastion
- Private

## 22. Data source AMI

## 23. EC2 Bastion

## 24. EC2 privada

## 25. Teste SSH

```
ssh -A ubuntu@bastion
ssh ubuntu@private
```

---

# 🔁 FASE 6 — ESCALA

## 26. for_each
## 27. count vs for_each
## 28. Conditionals
## 29. Data sources
## 30. Dynamic blocks

---

# 🧱 FASE 7 — MÓDULOS

## 31. Módulo VPC
## 32. Inputs
## 33. Módulo EC2
## 34. Reuso

---

# 🌍 FASE 8 — AMBIENTES

## 35. Multi-env

```
envs/dev
envs/prod
```

## 36. Workspaces

---

# 🔒 FASE 9 — SEGURANÇA

## 37. Dados sensíveis
## 38. Boas práticas

---

# 🧠 FASE 10 — AVANÇADO

## 39. Lifecycle
## 40. Import
## 41. State avançado
## 42. Debugging
## 43. Null resource

---

# 🚀 PROJETO FINAL

## 44. Projeto completo
- VPC
- Subnets
- NAT
- Bastion
- EC2 privada
- Módulos
- Backend remoto
