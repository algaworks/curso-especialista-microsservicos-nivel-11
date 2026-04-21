variable "aws_region" {
  default = "us-east-1"
}

variable "keypair_name" {
  type    = string
  default = "algadelivery-iac"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = "changeme123"
}
