output "vpc_id" {
  description = "ID da VPC"
  value       = aws_vpc.algadelivery.id
}

output "vpc_cidr" {
  description = "CIDR block da VPC"
  value       = aws_vpc.algadelivery.cidr_block
}
