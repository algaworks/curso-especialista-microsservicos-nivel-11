variable "environment" {
  description = "The environment name (development, homolog, production)"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "domain_name" {
  description = "The domain name for the ACM certificate (e.g. *.dev.algadelivery.com.br)"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "The ID of the Cloudflare zone that holds the validation records"
  type        = string
}

variable "dns_ttl" {
  description = "TTL of the DNS validation records, in seconds"
  type        = number
}

variable "validation_timeout" {
  description = "How long to wait for the ACM certificate validation"
  type        = string
}
