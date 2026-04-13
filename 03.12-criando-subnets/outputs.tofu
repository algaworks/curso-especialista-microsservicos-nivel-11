output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.algadelivery.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.algadelivery.arn
}

output "subnet_public_a_id" {
  description = "The ID of the public subnet A"
  value       = aws_subnet.public_a.id
}

output "subnet_public_a_arn" {
  description = "The ARN of the public subnet A"
  value       = aws_subnet.public_a.arn
}

output "subnet_public_b_id" {
  description = "The ID of the public subnet B"
  value       = aws_subnet.public_b.id
}

output "subnet_public_b_arn" {
  description = "The ARN of the public subnet B"
  value       = aws_subnet.public_b.arn
}

output "subnet_public_c_id" {
  description = "The ID of the public subnet C"
  value       = aws_subnet.public_c.id
}

output "subnet_public_c_arn" {
  description = "The ARN of the public subnet C"
  value       = aws_subnet.public_c.arn
}
