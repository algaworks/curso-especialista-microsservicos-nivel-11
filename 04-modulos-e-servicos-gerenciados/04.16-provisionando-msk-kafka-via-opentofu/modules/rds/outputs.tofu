output "db_subnet_group_name" { value = aws_db_subnet_group.this.name }
output "db_parameter_group_name" { value = aws_db_parameter_group.this.name }
output "security_group_id" { value = aws_security_group.rds.id }
output "endpoint" { value = aws_db_instance.this.endpoint }
output "port" { value = aws_db_instance.this.port }
output "db_name" { value = aws_db_instance.this.db_name }
output "db_instance_id" { value = aws_db_instance.this.id }
