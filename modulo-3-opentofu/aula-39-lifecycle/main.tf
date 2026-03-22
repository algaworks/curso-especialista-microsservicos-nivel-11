# ---------------------------------------------------------
# Aula 39: Lifecycle
#
# prevent_destroy    → bloqueia destroy acidental
# create_before_destroy → cria novo antes de destruir o antigo
# ignore_changes     → ignora mudanças em atributos específicos
# replace_triggered_by → força replace quando outro recurso muda
# ---------------------------------------------------------

resource "aws_security_group" "example" {
  name        = "${var.project_name}-sg-lifecycle"
  description = "Exemplo de lifecycle"
  vpc_id      = var.vpc_id

  ingress {

    from_port = 22

    to_port = 22

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "${var.project_name}-sg-lifecycle", Environment = var.environment }

  lifecycle {

    # Cria o novo SG antes de destruir o antigo (zero downtime em prod)

    create_before_destroy = true

    # Ignora mudanças manuais nas tags feitas fora do OpenTofu

    ignore_changes = [tags]

  }
}

resource "aws_s3_bucket" "critical" {
  bucket = "${var.project_name}-critical-data"

  lifecycle {

    # Protege contra destroy acidental — remova antes do tofu destroy

    prevent_destroy = true

  }
}
