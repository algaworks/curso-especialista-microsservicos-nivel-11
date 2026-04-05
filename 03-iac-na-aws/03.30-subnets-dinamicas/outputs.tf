output "bastion_public_ip" {
  description = "IP público do Bastion Host — use para conectar via SSH"
  value       = aws_instance.bastion.public_ip
}

output "private_instance_private_ip" {
  description = "IP privado da instância privada — acessível somente via Bastion"
  value       = aws_instance.private.private_ip
}

output "sg_bastion_id" {
  description = "ID do Security Group do Bastion Host"
  value       = aws_security_group.bastion.id
}

output "sg_private_id" {
  description = "ID do Security Group das instâncias privadas"
  value       = aws_security_group.private.id
}
