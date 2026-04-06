output "bastion_public_ip" { value = aws_instance.bastion.public_ip }
output "bastion_instance_id" { value = aws_instance.bastion.id }
output "sg_bastion_id" { value = aws_security_group.bastion.id }
output "private_instance_ip" { value = var.create_private_instance ? aws_instance.private[0].private_ip : "" }
output "sg_private_id" { value = var.create_private_instance ? aws_security_group.private[0].id : "" }
