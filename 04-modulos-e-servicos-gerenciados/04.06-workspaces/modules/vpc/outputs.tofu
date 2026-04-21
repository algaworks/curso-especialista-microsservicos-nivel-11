output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_arn" {
  value = aws_vpc.this.arn
}

output "vpc_cidr_block" {
  value = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public : subnet.id]
}

output "public_subnet_arns" {
  value = [for subnet in aws_subnet.public : subnet.arn]
}

output "private_management_subnet_ids" {
  value = [for subnet in aws_subnet.private_management : subnet.id]
}

output "private_management_subnet_arns" {
  value = [for subnet in aws_subnet.private_management : subnet.arn]
}

output "private_cluster_subnet_ids" {
  value = [for subnet in aws_subnet.private_cluster : subnet.id]
}

output "private_cluster_subnet_arns" {
  value = [for subnet in aws_subnet.private_cluster : subnet.arn]
}

output "igw_id" {
  value = aws_internet_gateway.this.id
}

output "igw_arn" {
  value = aws_internet_gateway.this.arn
}

output "ngw_id" {
  value = aws_nat_gateway.this.id
}

output "route_table_public_id" {
  value = aws_route_table.public.id
}

output "route_table_private_id" {
  value = aws_route_table.private.id
}
