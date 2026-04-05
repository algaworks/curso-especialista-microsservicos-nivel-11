output "bastion_public_ip" {
  description = "IP público do Bastion Host"
  value       = aws_instance.bastion.public_ip
}

output "bastion_instance_id" {
  value = aws_instance.bastion.id
}

output "sg_bastion_id" {
  value = aws_security_group.bastion.id
}
