locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "OpenTofu"
  }

  # Builtin function: upper() - Converte strings para maiúsculas
  environment_upper = upper(var.environment)

  # Builtin function: format() - Formata strings
  vpc_name = format("%s-vpc-%s", var.project_name, var.environment)

  # Builtin function: for - Cria um mapa de subnets
  subnet_map = {
    for config in var.subnet_configs :
    config.name => {
      cidr_block = config.cidr_block
      az         = "${var.aws_region}${config.availability_zone}"
    }
  }

  # Builtin function: merge() - Mescla maps
  # Adicionando tags específicas às subnets
  subnet_tags = {
    for config in var.subnet_configs :
    config.name => merge(local.common_tags, {
      Name = format("subnet-%s", config.name)
      Tier = "public"
    })
  }
}
