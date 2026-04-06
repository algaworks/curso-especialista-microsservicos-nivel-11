output "vpc_id" {
  value = aws_vpc.algadelivery.id
}

output "igw_id" {
  description = "ID do Internet Gateway"
  value       = aws_internet_gateway.algadelivery.id
}

output "public_subnet_ids" {
  value = [aws_subnet.pub_a.id, aws_subnet.pub_b.id, aws_subnet.pub_c.id]
}
