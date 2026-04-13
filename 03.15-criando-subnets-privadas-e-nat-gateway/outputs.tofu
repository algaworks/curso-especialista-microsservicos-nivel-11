output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.algadelivery.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.algadelivery.arn
}

output "subnet_public_id" {
  description = "The IDs of the public subnet "
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "subnet_public_arn" {
  description = "The ARNs of the public subnets"
  value       = [for subnet in aws_subnet.public : subnet.arn]
}

output "subnet_pvt_mgmt_id" {
  description = "The IDs of the private management subnets"
  value       = [for subnet in aws_subnet.private_management : subnet.id]
}

output "subnet_pvt_mgmt_arn" {
  description = "The ARNs of the private management subnets"
  value       = [for subnet in aws_subnet.private_management : subnet.arn]
}
output "subnet_pvt_cluster_id" {
  description = "The IDs of the private cluster subnets"
  value       = [for subnet in aws_subnet.private_cluster : subnet.id]
}

output "subnet_pvt_cluster_arn" {
  description = "The ARNs of the private cluster subnets"
  value       = [for subnet in aws_subnet.private_cluster : subnet.arn]
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value = aws_internet_gateway.algadelivery.id
}

output "igw_arn" {
  description = "The ARN of the Internet Gateway"
  value = aws_internet_gateway.algadelivery.arn
}

output "ngw_id" {
  description = "The ID of the NAT Gateway"
  value = aws_nat_gateway.algadelivery.id
}