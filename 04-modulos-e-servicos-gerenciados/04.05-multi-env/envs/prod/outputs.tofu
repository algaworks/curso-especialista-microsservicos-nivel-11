output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_arn" {
  value = module.vpc.vpc_arn
}

output "subnet_public_ids" {
  value = module.vpc.public_subnet_ids
}

output "subnet_pvt_mgmt_ids" {
  value = module.vpc.private_management_subnet_ids
}

output "subnet_pvt_cluster_ids" {
  value = module.vpc.private_cluster_subnet_ids
}

output "igw_id" {
  value = module.vpc.igw_id
}

output "ngw_id" {
  value = module.vpc.ngw_id
}

output "bastion_id" {
  value = module.ec2.bastion_id
}

output "bastion_public_ip" {
  value = module.ec2.bastion_public_ip
}

output "vm_private_id" {
  value = module.ec2.vm_private_id
}

output "vm_private_private_ip" {
  value = module.ec2.vm_private_private_ip
}

output "security_group_bastion_id" {
  value = module.ec2.security_group_bastion_id
}

output "security_group_vm_private_id" {
  value = module.ec2.security_group_vm_private_id
}
