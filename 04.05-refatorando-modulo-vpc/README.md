# 04.04 — Tipos de Coleção e For Expressions no OpenTofu

## Objetivo da aula

Entender os tipos de coleção `list`, `tuple` e `map` do OpenTofu/HCL e aprender a
transformar coleções com **for expressions**, base necessária para o próximo passo de
melhoria do módulo VPC.

---

## Tipos de coleção

### list

Sequência ordenada onde **todos os elementos têm o mesmo tipo**.

```hcl
variable "azs" {
  type    = list(string)
  default = ["a", "b", "c"]
}
```

- Acesso por índice: `var.azs[0]` → `"a"`
- Tamanho: `length(var.azs)` → `3`

---

### tuple

Sequência ordenada onde **cada posição pode ter um tipo diferente**.

```hcl
# declaração implícita — OpenTofu infere o tipo
["texto", 42, true]
```

Não é declarada explicitamente em variáveis com frequência; aparece como resultado
intermediário de for expressions e ao trabalhar com `splat`.

---

### map

Coleção de pares chave → valor, **sem ordem garantida**, onde todos os valores têm o
mesmo tipo.

```hcl
variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Owner       = "algaworks"
  }
}
```

- Acesso por chave: `var.tags["Environment"]` → `"dev"`
- Chaves: `keys(var.tags)` → `["Environment", "Owner"]`
- Valores: `values(var.tags)` → `["dev", "algaworks"]`

---

### object

Semelhante ao map, mas **cada chave pode ter um tipo diferente**. Usado para
estruturar objetos com campos nomeados.

```hcl
variable "subnet_config" {
  type = object({
    cidr_block = string
    az         = string
  })
  default = {
    cidr_block = "172.25.0.0/24"
    az         = "a"
  }
}
```

---

### Comparativo rápido

| Tipo    | Ordem | Tipos dos elementos | Acesso      |
|---------|-------|---------------------|-------------|
| list    | sim   | todos iguais        | índice `[0]`|
| tuple   | sim   | podem ser diferentes| índice `[0]`|
| map     | não   | todos iguais        | chave `["k"]`|
| object  | não   | podem ser diferentes| chave `["k"]`|

---

## For expressions

For expressions permitem **transformar** coleções sem precisar de loops imperativos.

### Produzindo uma tuple (lista)

```hcl
[for <valor> in <coleção> : <expressão>]

# exemplos
[for az in ["a", "b", "c"] : "us-east-1${az}"]
# => ["us-east-1a", "us-east-1b", "us-east-1c"]

[for k, v in { "x" = 1, "y" = 2 } : "${k}=${v}"]
# => ["x=1", "y=2"]
```

### Produzindo um mapa

```hcl
{for <chave>, <valor> in <coleção> : <nova_chave> => <novo_valor>}

# exemplos
{for k, v in { "a" = 1, "b" = 2 } : k => v * 10}
# => { "a" = 10, "b" = 20 }

{for idx, az in ["a", "b", "c"] : az => idx}
# => { "a" = 0, "b" = 1, "c" = 2 }
```

### Com filtro (cláusula `if`)

```hcl
[for v in [1, 2, 3, 4, 5] : v if v > 2]
# => [3, 4, 5]

{for k, v in { "a" = 1, "b" = 2, "c" = 3 } : k => v if v > 1}
# => { "b" = 2, "c" = 3 }
```

---

## Praticando no console

Abra o console na raiz do projeto:

```bash
cd 04.04-melhorando-modulo-vpc
tofu console
```

### Exercícios — execute no console

```hcl
# 1. list simples
["a", "b", "c"]

# 2. acesso por índice
["a", "b", "c"][1]

# 3. map simples
{ "us-east-1a" = "172.25.0.0/24", "us-east-1b" = "172.25.1.0/24" }

# 4. keys e values
keys({ "x" = 1, "y" = 2 })
values({ "x" = 1, "y" = 2 })

# 5. for produzindo lista
[for az in ["a", "b", "c"] : "us-east-1${az}"]

# 6. for produzindo mapa
{for az in ["a", "b", "c"] : az => "172.25.${index(["a","b","c"], az)}.0/24"}

# 7. for com filtro
[for v in [1, 2, 3, 4, 5] : v if v % 2 == 0]

# 8. for sobre mapa — iterando chave e valor
{for k, v in { "mgmt" = "10.0.0.0/24", "cluster" = "10.0.1.0/24" } : v => k}

# 9. mapa de objetos (padrão que usaremos nas subnets)
{
  "pvt_mgmt_a" = { cidr_block = "172.25.4.0/24", az = "a" }
  "pvt_mgmt_b" = { cidr_block = "172.25.5.0/24", az = "b" }
}

# 10. for sobre mapa de objetos — extraindo só o cidr_block
{for k, v in {
  "pvt_mgmt_a" = { cidr_block = "172.25.4.0/24", az = "a" }
  "pvt_mgmt_b" = { cidr_block = "172.25.5.0/24", az = "b" }
} : k => v.cidr_block}
```

---

## Próxima aula

Na próxima aula aplicamos esses conceitos para refatorar o módulo VPC, substituindo
variáveis hardcoded por uma única variável `map(map(object))` e um `for_each`
completamente dinâmico.
