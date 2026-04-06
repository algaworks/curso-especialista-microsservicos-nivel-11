output "vpc_id" { value = aws_vpc.algadelivery.id }
output "igw_id" { value = aws_internet_gateway.algadelivery.id }

output "public_subnet_ids" {
  value = [aws_subnet.pub_a.id, aws_subnet.pub_b.id, aws_subnet.pub_c.id]
}

output "management_subnet_ids" {
  description = "IDs das subnets de management (privadas)"
  value = [
    aws_subnet.management_a.id,
    aws_subnet.management_b.id,
    aws_subnet.management_c.id,
  ]
}

output "cluster_subnet_ids" {
  description = "IDs das subnets de cluster (privadas)"
  value = [
    aws_subnet.cluster_a.id,
    aws_subnet.cluster_b.id,
    aws_subnet.cluster_c.id,
  ]
}
