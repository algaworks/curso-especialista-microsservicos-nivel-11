output "vpc_id" { value = module.vpc.vpc_id }
output "subnet_public_ids" { value = module.vpc.public_subnet_ids }
output "subnet_pvt_mgmt_ids" { value = module.vpc.private_management_subnet_ids }
output "subnet_pvt_cluster_ids" { value = module.vpc.private_cluster_subnet_ids }
output "bastion_public_ip" { value = module.ec2.bastion_public_ip }
output "vm_private_private_ip" { value = module.ec2.vm_private_private_ip }
