resource "aws_security_group" "msk" {
  name        = "${var.context_name}-msk-sg"
  description = "Security group for Amazon MSK (Kafka)"
  vpc_id      = var.vpc_id

  ingress {
    description = "Kafka plaintext from VPC"
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    description = "Kafka TLS from VPC"
    from_port   = 9094
    to_port     = 9094
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "${var.context_name}-msk-sg" })
}

resource "aws_msk_configuration" "this" {
  name           = "${var.context_name}-msk-config"
  kafka_versions = [var.kafka_version]

  server_properties = <<-EOT
    auto.create.topics.enable=false
    delete.topic.enable=true
    default.replication.factor=2
    min.insync.replicas=1
    num.io.threads=8
    num.network.threads=5
    num.partitions=1
    num.replica.fetchers=2
    replica.lag.time.max.ms=30000
    socket.request.max.bytes=104857600
    unclean.leader.election.enable=true
  EOT
}

resource "aws_msk_cluster" "this" {
  cluster_name           = "${var.context_name}-${var.cluster_name}"
  kafka_version          = var.kafka_version
  number_of_broker_nodes = length(var.subnet_ids)

  broker_node_group_info {
    instance_type  = var.broker_instance_type
    client_subnets = var.subnet_ids

    storage_info {
      ebs_storage_info {
        volume_size = var.ebs_volume_size
      }
    }

    security_groups = [aws_security_group.msk.id]
  }

  configuration_info {
    arn      = aws_msk_configuration.this.arn
    revision = aws_msk_configuration.this.latest_revision
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS_PLAINTEXT"
      in_cluster    = true
    }
  }

  tags = merge(var.common_tags, { Name = "${var.context_name}-msk" })
}
