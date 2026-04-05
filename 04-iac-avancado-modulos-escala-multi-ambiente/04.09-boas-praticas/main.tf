# ---------------------------------------------------------
# Aula 38: Boas práticas de segurança
#
# 1. Nunca commitar credenciais AWS ou senhas
# 2. Sempre marcar variáveis sensíveis como sensitive = true
# 3. Usar IAM roles com least privilege
# 4. Habilitar versioning no bucket de tfstate
# 5. Criptografar o bucket de tfstate (AES256)
# 6. Bloquear acesso público ao bucket de tfstate
# 7. Usar DynamoDB lock para evitar concorrência
# 8. Restringir o CIDR de SSH do Bastion ao seu IP
# 9. Não usar AMIs públicas desconhecidas
# 10. Manter providers/tofu atualizados
# ---------------------------------------------------------

# Exemplo: Security Group com SSH restrito ao IP do operador
resource "aws_security_group" "bastion_secure" {
  name        = "${var.project_name}-sg-bastion-secure"
  description = "Bastion com SSH restrito"
  vpc_id      = var.vpc_id

  ingress {

    description = "SSH restrito ao IP da equipe - altere para seu IP!"

    from_port = 22

    to_port = 22

    protocol = "tcp"

    # Em producao, substitua pelo IP estatico da sua equipe (ex: 203.0.113.1/32):
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name        = "${var.project_name}-sg-bastion-secure"
    Environment = var.environment
  }
}
