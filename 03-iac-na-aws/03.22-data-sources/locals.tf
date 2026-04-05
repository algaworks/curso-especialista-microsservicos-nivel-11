locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "OpenTofu"
  }

  # =========================================================================
  # NOVO: mapeamento de sufixo (a/b/c) para nome real de AZ via data source
  # Antes usávamos: "${var.aws_region}${each.key}" (hardcodado)
  # Agora usamos:    local.az_by_suffix[each.key]   (dinâmico)
  # =========================================================================
  az_by_suffix = {
    a = data.aws_availability_zones.available.names[0]
    b = data.aws_availability_zones.available.names[1]
    c = data.aws_availability_zones.available.names[2]
  }
}
