output "vpc_id" { value = module.vpc.vpc_id }
output "bastion_public_ip" { value = module.ec2.bastion_public_ip }
output "vm_private_private_ip" { value = module.ec2.vm_private_private_ip }
output "rds_endpoint" { value = module.rds.endpoint }
output "rds_port" { value = module.rds.port }
output "elasticache_endpoint" { value = module.elasticache.primary_endpoint }
output "msk_bootstrap_brokers_tls" { value = module.msk.bootstrap_brokers_tls }
output "msk_zookeeper_connect" { value = module.msk.zookeeper_connect }
