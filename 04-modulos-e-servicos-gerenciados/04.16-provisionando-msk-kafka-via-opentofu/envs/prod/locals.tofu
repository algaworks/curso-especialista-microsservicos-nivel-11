locals {
  config              = yamldecode(file("${path.module}/../../config/prod-config.yml"))
  context_name        = "algadelivery"
  internet_cidr_block = "0.0.0.0/0"
  my_public_ip        = "${trimspace(data.http.my_public_ip.response_body)}/32"

  common_tags = {
    Environment = local.config.environment
    ManagedBy   = "OpenTofu"
  }
}
