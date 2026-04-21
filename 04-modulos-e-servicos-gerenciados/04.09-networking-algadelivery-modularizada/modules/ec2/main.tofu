resource "aws_security_group" "bastion" {
  name        = "bastion_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.bastion_ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.bastion_egress_rules
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.common_tags, {
    Name = "bastion_sg"
  })
}

resource "aws_security_group" "vm_private" {
  name        = "vm_private_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.vm_private_ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.vm_private_egress_rules
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.common_tags, {
    Name = "vm_private_sg"
  })
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = var.keypair_name
  public_key = tls_private_key.this.public_key_openssh
}

resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.this.private_key_pem
  filename        = "${path.module}/${var.keypair_name}.pem"
  file_permission = "0400"
}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  domain   = "vpc"
}

resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  key_name                    = var.keypair_name
  associate_public_ip_address = true

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(var.common_tags, {
    Name = "${var.context_name}-bastion"
  })

  depends_on = [aws_key_pair.this]
}

resource "aws_instance" "vm_private" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_management_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.vm_private.id]
  key_name               = var.keypair_name

  lifecycle {
    ignore_changes = [ami]
  }

  tags = merge(var.common_tags, {
    Name = "${var.context_name}-vm-private"
  })

  depends_on = [aws_key_pair.this]
}
