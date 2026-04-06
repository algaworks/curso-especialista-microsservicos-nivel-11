# ---------------------------------------------------------
# Aula 37: Dados Sensíveis
#
# Boas práticas para dados sensíveis:
# 1. Marque variáveis como `sensitive = true`
# 2. Use variáveis de ambiente: TF_VAR_db_password=...
# 3. Use AWS Secrets Manager ou Parameter Store (recomendado)
# 4. NUNCA commite terraform.tfvars com senhas no Git
# 5. Adicione *.tfvars ao .gitignore
# ---------------------------------------------------------

# Armazenar senha no AWS Secrets Manager (seguro!)
resource "aws_secretsmanager_secret" "db_password" {
  name        = "/${var.project_name}/db/password"
  description = "Senha do banco de dados do AlgaDelivery"

  tags = {
    Project   = var.project_name
    ManagedBy = "OpenTofu"
  }
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id = aws_secretsmanager_secret.db_password.id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}

# Buscar segredo existente com data source
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id  = aws_secretsmanager_secret.db_password.id
  depends_on = [aws_secretsmanager_secret_version.db_password]
}

# Output SENSÍVEL — mascarado nos logs
output "secret_arn" {
  description = "ARN do segredo"
  value       = aws_secretsmanager_secret.db_password.arn
}
