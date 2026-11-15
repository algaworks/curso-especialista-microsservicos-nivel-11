output "certificate_arn" {
  description = "The ARN of the validated ACM certificate (use it in the Ingress certificate-arn annotation)"
  value       = aws_acm_certificate_validation.main.certificate_arn
}

output "domain_name" {
  description = "The domain name covered by the certificate"
  value       = aws_acm_certificate.main.domain_name
}

output "validation_record_names" {
  description = "The DNS records created on Cloudflare to validate the certificate"
  value       = [for record in cloudflare_dns_record.validation : record.name]
}
