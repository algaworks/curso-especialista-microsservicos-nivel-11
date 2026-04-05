locals {
  all_traffic_cidr = "0.0.0.0/0"
  my_ip_cidr       = "${trimspace(data.http.my_public_ip.response_body)}/32"

  # cidrsubnet(prefix, newbits, netnum)
  #   prefix  — CIDR base da VPC            → "172.25.0.0/16"
  #   newbits — bits adicionados ao prefixo → 8 (16 + 8 = /24)
  #   netnum  — índice da sub-rede          → determina o 3º octeto
  #
  # Resultado: cidrsubnet("172.25.0.0/16", 8, N) → "172.25.N.0/24"

  public_subnet_cidrs = {
    a = cidrsubnet(var.vpc_cidr, 8, 1) # → 172.25.1.0/24
    b = cidrsubnet(var.vpc_cidr, 8, 2) # → 172.25.2.0/24
    c = cidrsubnet(var.vpc_cidr, 8, 3) # → 172.25.3.0/24
  }

  management_subnet_cidrs = {
    a = cidrsubnet(var.vpc_cidr, 8, 4) # → 172.25.4.0/24
    b = cidrsubnet(var.vpc_cidr, 8, 5) # → 172.25.5.0/24
    c = cidrsubnet(var.vpc_cidr, 8, 6) # → 172.25.6.0/24
  }

  cluster_subnet_cidrs = {
    a = cidrsubnet(var.vpc_cidr, 8, 7) # → 172.25.7.0/24
    b = cidrsubnet(var.vpc_cidr, 8, 8) # → 172.25.8.0/24
    c = cidrsubnet(var.vpc_cidr, 8, 9) # → 172.25.9.0/24
  }

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "OpenTofu"
  }

  az_by_suffix = {
    a = data.aws_availability_zones.available.names[0]
    b = data.aws_availability_zones.available.names[1]
    c = data.aws_availability_zones.available.names[2]
  }
}
