resource "aws_security_group" "rds" {
  name        = "${var.context_name}-rds-sg"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "${var.context_name}-rds-sg" })
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.context_name}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.common_tags, { Name = "${var.context_name}-db-subnet-group" })
}

resource "aws_db_parameter_group" "this" {
  name   = "${var.context_name}-pg-params"
  family = "postgres${var.engine_major_version}"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  tags = merge(var.common_tags, { Name = "${var.context_name}-pg-params" })
}

resource "aws_db_instance" "this" {
  identifier             = "${var.context_name}-postgres"
  engine                 = "postgres"
  engine_version         = var.engine_version
  instance_class         = var.db_instance_class
  allocated_storage      = var.allocated_storage
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  parameter_group_name   = aws_db_parameter_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
  multi_az               = false

  tags = merge(var.common_tags, { Name = "${var.context_name}-postgres" })
}
