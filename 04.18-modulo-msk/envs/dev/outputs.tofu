output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.vpc.vpc_arn
}

output "subnet_public_ids" {
  description = "The IDs of the public subnets"
  value       = module.vpc.subnet_pub_ids["public"]
}

output "subnet_public_arn" {
  description = "The ARNs of the public subnets"
  value       = module.vpc.subnet_pub_arns["public"]
}

output "subnet_pvt_mgmt_ids" {
  description = "The IDs of the private management subnets"
  value       = module.vpc.subnet_pvt_ids["management"]
}

output "subnet_pvt_mgmt_arns" {
  description = "The ARNs of the private management subnets"
  value       = module.vpc.subnet_pvt_arns["management"]
}

output "subnet_pvt_cluster_id" {
  description = "The IDs of the private cluster subnets"
  value       = module.vpc.subnet_pvt_ids["cluster"]
}

output "subnet_pvt_cluster_arn" {
  description = "The ARNs of the private cluster subnets"
  value       = module.vpc.subnet_pvt_arns["cluster"]
}

output "subnet_pvt_database_ids" {
  description = "The IDs of the private database subnets"
  value       = module.vpc.subnet_pvt_ids["database"]
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc.igw_id
}

output "igw_arn" {
  description = "The ARN of the Internet Gateway"
  value       = module.vpc.igw_arn
}

output "ngw_id" {
  description = "The ID of the NAT Gateway"
  value       = module.vpc.ngw_id
}

output "route_table_public_id" {
  description = "The ID of the public route table"
  value       = module.vpc.route_table_public_id
}

output "route_table_private_id" {
  description = "The ID of the private route table"
  value       = module.vpc.route_table_private_id
}

output "bastion_id" {
  description = "The ID of the bastion instance"
  value       = module.bastion.id
}

output "bastion_arn" {
  description = "The ARN of the bastion instance"
  value       = module.bastion.arn
}

output "bastion_public_ip" {
  description = "The public IP of the bastion instance"
  value       = module.bastion.public_ip
}

output "keypair_arn" {
  description = "The ARN of the key pair"
  value       = module.bastion.keypair_arn
}

output "security_group_bastion_id" {
  description = "The ID of the bastion security group"
  value       = module.bastion.security_group_id
}

output "rds_endpoint" {
  description = "The connection endpoint of the RDS instance"
  value       = module.rds.endpoint
}

output "rds_port" {
  description = "The port the RDS instance is listening on"
  value       = module.rds.port
}

output "rds_db_name" {
  description = "The name of the database"
  value       = module.rds.db_name
}

output "rds_instance_id" {
  description = "The ID of the RDS instance"
  value       = module.rds.db_instance_id
}

output "security_group_rds_id" {
  description = "The ID of the RDS security group"
  value       = module.rds.security_group_id
}

output "msk_bootstrap_brokers" {
  description = "Plaintext connection host:port pairs for the MSK cluster"
  value       = module.msk.bootstrap_brokers
}

output "msk_bootstrap_brokers_tls" {
  description = "TLS connection host:port pairs for the MSK cluster"
  value       = module.msk.bootstrap_brokers_tls
}

output "msk_zookeeper_connect_string" {
  description = "ZooKeeper connection string for the MSK cluster"
  value       = module.msk.zookeeper_connect_string
}

output "msk_arn" {
  description = "The ARN of the MSK cluster"
  value       = module.msk.arn
}

output "security_group_msk_id" {
  description = "The ID of the MSK security group"
  value       = module.msk.security_group_id
}
