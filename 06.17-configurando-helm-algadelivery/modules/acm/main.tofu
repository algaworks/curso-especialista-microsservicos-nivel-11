resource "aws_acm_certificate" "main" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-acm-certificate"
    }
  )
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in cloudflare_dns_record.validation : record.name]

  timeouts {
    create = var.validation_timeout
  }
}
