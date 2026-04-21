output "vpc_id" {
  value = module.vpc.vpc_id
}

output "bastion_public_ip" {
  value = module.ec2.bastion_public_ip
}

output "vm_private_private_ip" {
  value = module.ec2.vm_private_private_ip
}

output "current_workspace" {
  value = terraform.workspace
}
