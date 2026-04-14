resource "aws_security_group" "bastion" {
  name        = "bastion_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.algadelivery.id

  ingress {
    description = "SSH da internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.internet_cidr_block]
  }

  egress {
    description = "Todo o trafego de saida"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.internet_cidr_block]
  }

  tags = {
    Name        = "bastion_sg"
    Environment = var.environment
    ManagedBy   = "OpenTofu"
  }
}

resource "aws_security_group" "vm_private" {
  name        = "vm_private_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.algadelivery.id

  ingress {
    description = "SSH para VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.algadelivery.cidr_block]
  }

  egress {
    description = "Todo o trafego de saida"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.internet_cidr_block]
  }

  tags = {
    Name        = "vm_private_sg"
    Environment = var.environment
    ManagedBy   = "OpenTofu"
  }
}