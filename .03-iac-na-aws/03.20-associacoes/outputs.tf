output "vpc_id" { value = aws_vpc.algadelivery.id }
output "public_subnet_ids" { value = [aws_subnet.pub_a.id, aws_subnet.pub_b.id, aws_subnet.pub_c.id] }
output "management_subnet_ids" { value = [aws_subnet.management_a.id, aws_subnet.management_b.id, aws_subnet.management_c.id] }
output "cluster_subnet_ids" { value = [aws_subnet.cluster_a.id, aws_subnet.cluster_b.id, aws_subnet.cluster_c.id] }
output "rt_public_id" { value = aws_route_table.public.id }
output "rt_private_id" { value = aws_route_table.private.id }
