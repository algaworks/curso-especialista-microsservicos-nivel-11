output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.algadelivery.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.algadelivery.arn
}

output "subnet_public_id" {
  description = "The IDs of the public subnet "
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "subnet_public_arn" {
  description = "The ARNs of the public subnets"
  value       = [for subnet in aws_subnet.public : subnet.arn]
}