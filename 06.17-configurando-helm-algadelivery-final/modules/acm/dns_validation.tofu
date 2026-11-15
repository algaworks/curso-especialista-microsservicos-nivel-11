resource "cloudflare_dns_record" "validation" {
  # A chave e o domain_name, conhecido no plan. O nome e o valor do record
  # so existem depois que o ACM cria o certificado, por isso ficam no value.
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options :
    dvo.domain_name => {
      name    = dvo.resource_record_name
      type    = dvo.resource_record_type
      content = dvo.resource_record_value
    }
  }

  zone_id = var.cloudflare_zone_id
  name    = trimsuffix(each.value.name, ".")
  type    = each.value.type
  content = trimsuffix(each.value.content, ".")
  ttl     = var.dns_ttl
  proxied = false
  comment = "ACM certificate validation for ${var.environment} environment"
}
