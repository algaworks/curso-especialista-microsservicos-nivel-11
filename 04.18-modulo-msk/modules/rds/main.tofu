locals {
  pg_family = "postgres${split(".", var.engine_version)[0]}"
}

resource "aws_db_subnet_group" "main" {
  name       = var.db_subnet_group_name
  subnet_ids = var.subnet_ids

  tags = merge(var.common_tags, {
    Name = var.db_subnet_group_name
  })
}

resource "aws_db_parameter_group" "main" {
  name   = var.db_parameter_group_name
  family = local.pg_family

  dynamic "parameter" {
    for_each = var.db_parameter_group
    content {
      name         = parameter.key
      value        = parameter.value
      apply_method = "pending-reboot"
    }
  }

  tags = merge(var.common_tags, {
    Name = var.db_parameter_group_name
  })
}

resource "aws_security_group" "main" {
  name        = var.security_group_name
  description = "Security group for RDS PostgreSQL"
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL da VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "Todo o trafego de saida"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = var.security_group_name
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "main" {
  identifier             = var.db_identifier
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  engine                 = "postgres"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  db_subnet_group_name   = aws_db_subnet_group.main.name
  parameter_group_name   = aws_db_parameter_group.main.name
  vpc_security_group_ids = [aws_security_group.main.id]
  multi_az               = var.multi_az
  skip_final_snapshot    = var.skip_final_snapshot

  tags = merge(var.common_tags, {
    Name = var.db_identifier
  })

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [password]
  }
}


variable "db_parameter_group" {
  description = "Map of PostgreSQL parameter group settings (name = value)"
  type        = map(string)
  default = {
    "max_connections"         = "300"
    "shared_preload_libraries" = "pg_stat_statements,pgaudit"
  }
}
