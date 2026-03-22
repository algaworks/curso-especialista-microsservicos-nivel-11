# ---------------------------------------------------------
# Aula 30: Dynamic Blocks
#
# dynamic permite gerar blocos repetidos dentro de um recurso
# a partir de uma lista ou mapa — evita repetição manual.
# ---------------------------------------------------------
resource "aws_security_group" "dynamic_example" {
  name        = "${var.project_name}-sg-dynamic"
  description = "SG com regras dinâmicas"
  vpc_id      = var.vpc_id

  # Gera um bloco `ingress` para cada item da lista
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = { Name = "${var.project_name}-sg-dynamic", Environment = var.environment }
}

output "sg_id" { value = aws_security_group.dynamic_example.id }
