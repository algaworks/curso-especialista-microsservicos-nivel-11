output "vpc_id" { value = aws_vpc.this.id }
output "vpc_cidr" { value = aws_vpc.this.cidr_block }
output "igw_id" { value = aws_internet_gateway.this.id }
output "nat_gateway_id" { value = aws_nat_gateway.this.id }
output "nat_public_ip" { value = aws_eip.nat.public_ip }
output "public_subnet_ids" { value = { for k, s in aws_subnet.public : k => s.id } }
output "management_subnet_ids" { value = { for k, s in aws_subnet.management : k => s.id } }
output "cluster_subnet_ids" { value = { for k, s in aws_subnet.cluster : k => s.id } }
output "rt_public_id" { value = aws_route_table.public.id }
output "rt_private_id" { value = aws_route_table.private.id }
