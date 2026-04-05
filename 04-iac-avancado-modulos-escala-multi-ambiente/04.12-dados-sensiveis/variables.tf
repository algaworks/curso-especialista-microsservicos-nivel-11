variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "project_name" {
  type    = string
  default = "algadelivery"
}

# Variável marcada como sensitive: NÃO aparece no plano/output
variable "db_password" {
  description = "Senha do banco de dados"
  type        = string
  sensitive   = true
}

variable "db_username" {
  description = "Usuário do banco de dados"
  type        = string
  default     = "algadelivery_app"
}
