output "bastion_public_ip" { value = aws_instance.bastion.public_ip }
output "private_instance_private_ip" { value = aws_instance.private.private_ip }
output "sg_bastion_id" { value = aws_security_group.bastion.id }
output "sg_private_id" { value = aws_security_group.private.id }
