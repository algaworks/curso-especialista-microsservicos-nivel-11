# ---------------------------------------------------------
# Aula 27: count vs for_each
#
# COUNT: usa índice numérico (0, 1, 2...)
#   → Problema: remover item do meio reindesa os demais!
#
# FOR_EACH: usa chave estável (string ou objeto)
#   → Preferível para recursos identificados por nome/az/key
# ---------------------------------------------------------

# Exemplo com COUNT
resource "aws_subnet" "with_count" {
  count = var.subnet_count

  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name    = "subnet-count-${count.index}"
    Project = var.project_name
  }
}

# Exemplo com FOR_EACH (preferido!)
resource "aws_subnet" "with_for_each" {
  for_each = var.subnets_map

  vpc_id            = var.vpc_id
  cidr_block        = each.value
  availability_zone = each.key

  tags = {
    Name    = "subnet-foreach-${each.key}"
    Project = var.project_name
  }
}

# ---------------------------------------------------------
# Comparação de referência:
#   count:     aws_subnet.with_count[0].id
#   for_each:  aws_subnet.with_for_each["us-east-1a"].id
# ---------------------------------------------------------
