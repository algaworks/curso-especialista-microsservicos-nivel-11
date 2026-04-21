output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.main.arn
}

output "subnet_public_ids" {
  description = "The IDs of the public subnets"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "subnet_public_arns" {
  description = "The ARNs of the public subnets"
  value       = [for subnet in aws_subnet.public : subnet.arn]
}

output "subnet_pvt_mgmt_ids" {
  description = "The IDs of the private management subnets"
  value       = [for subnet in aws_subnet.private_management : subnet.id]
}

output "subnet_pvt_mgmt_arns" {
  description = "The ARNs of the private management subnets"
  value       = [for subnet in aws_subnet.private_management : subnet.arn]
}
output "subnet_pvt_cluster_ids" {
  description = "The IDs of the private cluster subnets"
  value       = [for subnet in aws_subnet.private_cluster : subnet.id]
}

output "subnet_pvt_cluster_arns" {
  description = "The ARNs of the private cluster subnets"
  value       = [for subnet in aws_subnet.private_cluster : subnet.arn]
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "igw_arn" {
  description = "The ARN of the Internet Gateway"
  value       = aws_internet_gateway.main.arn
}

output "ngw_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.main.id
}

output "route_table_public_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public.id
}

output "route_table_private_id" {
  description = "The ID of the private route table"
  value       = aws_route_table.private.id
}
