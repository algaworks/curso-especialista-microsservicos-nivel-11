locals {
  context_name        = "algadelivery"
  ngw_regional_mode   = var.ngw_regional_mode ? "regional" : "zonal"
  internet_cidr_block = "0.0.0.0/0"
  my_public_ip    = "${trimspace(data.http.my_public_ip.response_body)}/32"

  common_tags = {
    Environment = var.environment
    ManagedBy   = "OpenTofu"
  }
}