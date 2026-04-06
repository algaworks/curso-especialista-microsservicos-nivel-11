output "vpc_id" {
  value       = aws_vpc.algadelivery.id
  description = "ID da VPC criada"
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas usando builtin functions"
  value = [
    for subnet in aws_subnet.public :
    subnet.id
  ]
}

# Output demonstrando uso de builtin function: join()
output "public_subnet_ids_string" {
  description = "IDs das subnets públicas como string separada por vírgula"
  value = join(", ", [
    for subnet in aws_subnet.public :
    subnet.id
  ])
}

# Output demonstrando uso de builtin function: map()
output "subnet_details" {
  description = "Detalhes das subnets com mapeamento"
  value = {
    for name, subnet in aws_subnet.public :
    name => {
      id                = subnet.id
      cidr_block        = subnet.cidr_block
      availability_zone = subnet.availability_zone
    }
  }
}

# Output usando builtin function: length()
output "subnet_count" {
  description = "Quantidade de subnets criadas"
  value       = length(aws_subnet.public)
}
