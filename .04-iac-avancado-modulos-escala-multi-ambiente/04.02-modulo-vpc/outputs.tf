output "vpc_id" { value = module.vpc.vpc_id }
output "public_subnet_ids" { value = module.vpc.public_subnet_ids }
output "management_subnet_ids" { value = module.vpc.management_subnet_ids }
output "cluster_subnet_ids" { value = module.vpc.cluster_subnet_ids }
