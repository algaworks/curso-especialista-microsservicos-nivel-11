output "vpc_id" { value = module.vpc.vpc_id }
output "bastion_public_ip" { value = module.ec2.bastion_public_ip }
output "vm_private_private_ip" { value = module.ec2.vm_private_private_ip }
output "rds_subnet_group" { value = module.rds.db_subnet_group_name }
output "rds_endpoint" { value = module.rds.endpoint }
output "rds_port" { value = module.rds.port }
output "elasticache_endpoint" { value = module.elasticache.primary_endpoint }
