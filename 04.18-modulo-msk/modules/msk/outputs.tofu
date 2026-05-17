output "bootstrap_brokers" {
  description = "Plaintext connection host:port pairs"
  value       = aws_msk_cluster.main.bootstrap_brokers
}

output "bootstrap_brokers_tls" {
  description = "TLS connection host:port pairs"
  value       = aws_msk_cluster.main.bootstrap_brokers_tls
}

output "zookeeper_connect_string" {
  description = "A comma separated list of hostname:port pairs to connect to the ZooKeeper cluster"
  value       = aws_msk_cluster.main.zookeeper_connect_string
}

output "arn" {
  description = "The ARN of the MSK cluster"
  value       = aws_msk_cluster.main.arn
}

output "current_version" {
  description = "Current version of the MSK cluster used for updates"
  value       = aws_msk_cluster.main.current_version
}

output "security_group_id" {
  description = "The ID of the MSK security group"
  value       = aws_security_group.main.id
}
