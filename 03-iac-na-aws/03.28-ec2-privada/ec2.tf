resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.bastion_instance_type
  subnet_id                   = aws_subnet.public["a"].id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-bastion"
    Role = "bastion"
  })
}

resource "aws_instance" "private" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.private_instance_type
  subnet_id              = aws_subnet.management["a"].id
  vpc_security_group_ids = [aws_security_group.private.id]
  key_name               = var.key_name

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-private"
    Role = "management"
  })
}
