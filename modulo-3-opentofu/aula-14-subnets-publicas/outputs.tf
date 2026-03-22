output "vpc_id" {
  value = aws_vpc.algadelivery.id
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas"
  value = [
    aws_subnet.pub_a.id,
    aws_subnet.pub_b.id,
    aws_subnet.pub_c.id,
  ]
}
