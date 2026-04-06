resource "aws_vpc" "algadelivery" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = local.vpc_name
  })
}

# Subnets Públicas usando for_each com builtin functions
# Demonstra o uso de for_each para iterar sobre a lista de configurações
resource "aws_subnet" "public" {
  for_each = local.subnet_map

  vpc_id                  = aws_vpc.algadelivery.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = local.subnet_tags[each.key]
}

# Exemplo adicional: Filtrando subnets que começam com "pub" usando contains()
# Esta é uma forma de demonstrar como usar builtin functions para filtros
locals {
  public_subnet_ids = [
    for name, subnet in aws_subnet.public :
    subnet.id
    if contains([for config in var.subnet_configs : config.name], name)
  ]
}
