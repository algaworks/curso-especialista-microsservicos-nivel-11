output "sg_bastion_id" {
  description = "ID do Security Group do Bastion"
  value       = aws_security_group.bastion.id
}

output "sg_private_id" {
  description = "ID do Security Group das instâncias privadas"
  value       = aws_security_group.private.id
}
