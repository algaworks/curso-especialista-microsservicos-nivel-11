resource "aws_security_group" "algadelivery_msk" {
  name        = "${var.environment}-algadelivery-msk"
  description = "Security group for MSK cluster in ${var.environment} environment"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Access to MSK cluster"
    from_port   = 9098
    to_port     = 9098
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
    Name = "${var.environment}-algadelivery-msk"
  })

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_msk_serverless_cluster" "algadelivery" {
  cluster_name = "${var.environment}-algadelivery-msk"

  vpc_config {
    subnet_ids         = module.vpc.subnet_pvt_ids["management"]
    security_group_ids = [aws_security_group.algadelivery_msk.id]
  }

  client_authentication {
    sasl {
      iam {
        enabled = true
      }
    }
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment}-algadelivery-msk"
  })

  lifecycle {
    prevent_destroy = true
  }
}

output "msk_cluster_name" {
  description = "Name of the MSK cluster"
  value       = aws_msk_serverless_cluster.algadelivery.cluster_name
}

output "msk_arn" {
  description = "ARN of the MSK cluster"
  value       = aws_msk_serverless_cluster.algadelivery.arn
}

output "msk_endpoint" {
  description = "Endpoint of the MSK cluster"
  value       = aws_msk_serverless_cluster.algadelivery.bootstrap_brokers_sasl_iam
}