resource "aws_acm_certificate" "main" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = merge(
    local.common_tags,
    {
      Name = "${var.environment}-acm-certificate"
    }
  )
}

resource "cloudflare_dns_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options :
    dvo.domain_name => {
      name    = dvo.resource_record_name     # valores: podem chegar só no apply
      type    = dvo.resource_record_type
      content = dvo.resource_record_value
    }
  }

  zone_id = var.cloudflare_zone_id
  name    = trimsuffix(each.value.name, ".")
  type    = each.value.type
  content = trimsuffix(each.value.content, ".")
  ttl     = var.cloudflare_dns_ttl
  proxied = false
  comment = "ACM certificate validation for ${var.environment} environment"
}


resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in cloudflare_dns_record.validation : record.name]

  timeouts {
    create = var.cloudflare_validation_timeout
  }
}