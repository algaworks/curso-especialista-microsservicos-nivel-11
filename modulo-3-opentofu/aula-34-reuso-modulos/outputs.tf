output "vpc_id" { value = module.vpc.vpc_id }
output "bastion_public_ip" { value = module.ec2.bastion_public_ip }
output "private_instance_ip" { value = module.ec2.private_instance_ip }
