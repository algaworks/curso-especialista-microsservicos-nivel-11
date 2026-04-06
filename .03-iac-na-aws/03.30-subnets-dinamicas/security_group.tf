resource "aws_security_group" "bastion" {
  name        = "${var.project_name}-sg-bastion"
  description = "Security group do Bastion Host"
  vpc_id      = aws_vpc.algadelivery.id

  ingress {
    description = "SSH da internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_ip_cidr]
  }

  egress {
    description = "Trafego de saida liberado"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.all_traffic_cidr]
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-sg-bastion" })
}

resource "aws_security_group" "private" {
  name        = "${var.project_name}-sg-private"
  description = "Security group para instancias privadas"
  vpc_id      = aws_vpc.algadelivery.id

  ingress {
    description     = "SSH a partir do Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    description = "Trafego de saida liberado"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.all_traffic_cidr]
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-sg-private" })
}
