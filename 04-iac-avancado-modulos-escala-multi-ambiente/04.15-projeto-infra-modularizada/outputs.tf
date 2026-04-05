output "vpc_id" {
  description = "ID da VPC AlgaDelivery"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas"
  value       = module.vpc.public_subnet_ids
}

output "management_subnet_ids" {
  description = "IDs das subnets de management"
  value       = module.vpc.management_subnet_ids
}

output "cluster_subnet_ids" {
  description = "IDs das subnets de cluster"
  value       = module.vpc.cluster_subnet_ids
}

output "nat_public_ip" {
  description = "IP público do NAT Gateway"
  value       = module.vpc.nat_public_ip
}

output "bastion_public_ip" {
  description = "IP público do Bastion Host"
  value       = module.ec2.bastion_public_ip
}

output "private_instance_ip" {
  description = "IP privado da instância de management"
  value       = module.ec2.private_instance_ip
}

output "ssh_bastion" {
  description = "Comando SSH para o Bastion"
  value       = "ssh -A ubuntu@${module.ec2.bastion_public_ip}"
}

output "ssh_private" {
  description = "Comando SSH para a EC2 privada (a partir do Bastion)"
  value       = "ssh ubuntu@${module.ec2.private_instance_ip}"
}
