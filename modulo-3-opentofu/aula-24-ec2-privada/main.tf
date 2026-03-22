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
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_security_group" "bastion" {
  name        = "${var.project_name}-sg-bastion"
  description = "SSH ao Bastion"
  vpc_id      = var.vpc_id
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags, { Name = "${var.project_name}-sg-bastion" })
}

resource "aws_security_group" "private" {
  name        = "${var.project_name}-sg-private"
  description = "SSH via Bastion"
  vpc_id      = var.vpc_id
  ingress {
    description     = "SSH via Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags, { Name = "${var.project_name}-sg-private" })
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.bastion_instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  tags                        = merge(local.common_tags, { Name = "${var.project_name}-bastion", Role = "bastion" })
}

# EC2 Privada — fica na subnet de management, sem IP público
resource "aws_instance" "private" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.private_instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.private.id]
  key_name               = var.key_name

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-private"
    Role = "management"
  })
}
