resource "aws_security_group" "algadelivery_cache" {
  name        = "${var.environment}-cache-sg"
  description = "Security group for ElastiCache cluster in ${var.environment} environment"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow Redis traffic from application servers"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.internet_cidr_block]
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment}-cache-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_elasticache_serverless_cache" "algadelivery" {
  name        = "${var.environment}-${var.cache_name}"
  description = "ElastiCache Serverless cluster for ${var.environment} environment"

  engine               = var.cache_engine
  major_engine_version = var.cache_engine_version


  cache_usage_limits {
    data_storage {
      maximum = var.cache_data_storage.maximum
      minimum = var.cache_data_storage.minimum
      unit    = var.cache_data_storage.unit
    }
    ecpu_per_second {
      maximum = var.cache_request_ecpu.maximum
      minimum = var.cache_request_ecpu.minimum
    }
  }

  security_group_ids = [aws_security_group.algadelivery_cache.id]
  subnet_ids         = module.vpc.subnet_pvt_ids["management"]

  daily_snapshot_time      = var.cache_daily_snapshot_time
  snapshot_retention_limit = var.cache_snapshot_retention_limit

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${var.cache_name}"
  })

  lifecycle {
    prevent_destroy = true
  }
}

variable "cache_name" {
  description = "Name for the ElastiCache Serverless"
  type        = string
  default     = "algadelivery-cache"
}

variable "cache_engine" {
  description = "The engine for the ElastiCache Serverless"
  type        = string
  default     = "valkey"
}

variable "cache_engine_version" {
  description = "The engine version for the ElastiCache Serverless"
  type        = string
  default     = "9"
}

variable "cache_daily_snapshot_time" {
  description = "The time at which to take daily snapshots"
  type        = string
  default     = "02:00"
}

variable "cache_snapshot_retention_limit" {
  description = "The number of days to retain snapshot copies"
  type        = string
  default     = "1"
}

variable "cache_request_ecpu" {
  description = "The number of eCPU units to request for the ElastiCache Serverless"
  type        = map(number)
  default = {
    maximum = 5000
    minimum = 1000
  }
}

variable "cache_data_storage" {
  description = "The amount of data storage to allocate for the ElastiCache Serverless"
  type        = map(string)
  default = {
    maximum = "10"
    minimum = "1"
    unit    = "GB"
  }
}

output "elasticache_endpoint" {
  value = aws_elasticache_serverless_cache.algadelivery.endpoint
}

output "elasticache_arn" {
  value = aws_elasticache_serverless_cache.algadelivery.arn
}

