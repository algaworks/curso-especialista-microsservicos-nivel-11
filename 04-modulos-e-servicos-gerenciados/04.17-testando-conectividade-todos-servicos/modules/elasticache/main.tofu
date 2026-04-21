resource "aws_security_group" "elasticache" {
  name        = "${var.context_name}-elasticache-sg"
  description = "Security group for ElastiCache Valkey"
  vpc_id      = var.vpc_id

  ingress {
    description = "Valkey from VPC"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "${var.context_name}-elasticache-sg" })
}

resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.context_name}-cache-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.common_tags, { Name = "${var.context_name}-cache-subnet-group" })
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id = "${var.context_name}-valkey"
  description          = "Valkey replication group for ${var.context_name}"
  engine               = "valkey"
  engine_version       = var.engine_version
  node_type            = var.node_type
  num_cache_clusters   = var.num_cache_clusters
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.this.name
  security_group_ids   = [aws_security_group.elasticache.id]

  tags = merge(var.common_tags, { Name = "${var.context_name}-valkey" })
}
