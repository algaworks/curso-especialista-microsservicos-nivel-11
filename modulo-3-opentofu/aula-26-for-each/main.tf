# ---------------------------------------------------------
# Aula 26: for_each
#
# Cria múltiplas subnets a partir de um mapa de AZ → CIDR.
# for_each cria uma instância do recurso para cada chave do mapa,
# permitindo identificar cada instância por uma chave estável.
# ---------------------------------------------------------
resource "aws_subnet" "public" {
  for_each = var.subnets

  vpc_id                  = var.vpc_id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name    = "subnet-pub-${each.key}"
    Project = var.project_name
  }
}

# Listar IDs criados com for expression
output "subnet_ids" {
  value = { for az, subnet in aws_subnet.public : az => subnet.id }
}
