# ---------------------------------------------------------
# Aula 28: Condicionais
#
# Sintaxe: condition ? true_value : false_value
# count = var.create_bastion ? 1 : 0  → cria ou não cria
# ---------------------------------------------------------

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "bastion" {
  count = var.create_bastion ? 1 : 0

  name        = "${var.project_name}-sg-bastion"
  description = "SSH ao Bastion"
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
  tags = {
    Name        = "${var.project_name}-sg-bastion"
    Environment = var.environment
  }
}

resource "aws_instance" "bastion" {
  count = var.create_bastion ? 1 : 0

  ami = data.aws_ami.ubuntu.id
  # Tipo de instância: t3.micro em dev, t3.small em prod
  instance_type               = var.environment == "prod" ? "t3.small" : "t3.micro"
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.bastion[0].id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name        = "${var.project_name}-bastion"
    Environment = var.environment
  }
}

output "bastion_ip" {
  # Condicional no output: retorna IP ou mensagem
  value = var.create_bastion ? aws_instance.bastion[0].public_ip : "Bastion não criado"
}
