output "vpc_id" { value = aws_vpc.algadelivery.id }
output "igw_id" { value = aws_internet_gateway.algadelivery.id }
output "nat_gateway_id" { value = aws_nat_gateway.algadelivery.id }
output "nat_eip" { value = aws_eip.nat.public_ip }
output "public_subnet_ids" { value = [aws_subnet.pub_a.id, aws_subnet.pub_b.id, aws_subnet.pub_c.id] }
output "management_subnet_ids" { value = [aws_subnet.management_a.id, aws_subnet.management_b.id, aws_subnet.management_c.id] }
output "cluster_subnet_ids" { value = [aws_subnet.cluster_a.id, aws_subnet.cluster_b.id, aws_subnet.cluster_c.id] }
