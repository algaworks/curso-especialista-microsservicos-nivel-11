module "acm" {
  source = "./modules/acm"

  environment = var.environment
  common_tags = local.common_tags

  domain_name        = var.domain_name
  cloudflare_zone_id = var.cloudflare_zone_id
  dns_ttl            = var.cloudflare_dns_ttl
  validation_timeout = var.cloudflare_validation_timeout
}
