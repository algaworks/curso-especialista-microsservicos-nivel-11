variable "aws_region" {
  default = "us-east-1"
}

variable "environment" {
  description = "The environment for the S3 bucket (development, homolog, production)"
  type        = string
  default     = "production"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "172.26.0.0/16"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "algadelivery-vpc"
}

variable "subnet_pub_config" {
  description = "Configuration for public subnets grouped by name (e.g. public, dmz)"
  type = map(map(object({
    cidr_block = string
    az         = string
  })))
  default = {
    public = {
      "pub_a" = { cidr_block = "172.26.1.0/24", az = "a" },
      "pub_b" = { cidr_block = "172.26.2.0/24", az = "b" },
      "pub_c" = { cidr_block = "172.26.3.0/24", az = "c" }
    }
  }
}

variable "subnet_pvt_config" {
  description = "Configuration for private subnets grouped by name (e.g. management, cluster)"
  type = map(map(object({
    cidr_block = string
    az         = string
  })))
  default = {
    management = {
      "pvt_mgmt_a" = { cidr_block = "172.26.4.0/24", az = "a" },
      "pvt_mgmt_b" = { cidr_block = "172.26.5.0/24", az = "b" },
      "pvt_mgmt_c" = { cidr_block = "172.26.6.0/24", az = "c" }
    },
    cluster = {
      "pvt_cluster_a" = { cidr_block = "172.26.7.0/24", az = "a" },
      "pvt_cluster_b" = { cidr_block = "172.26.8.0/24", az = "b" },
      "pvt_cluster_c" = { cidr_block = "172.26.9.0/24", az = "c" }
    },
    database = {
      "pvt_db_a" = { cidr_block = "172.26.10.0/24", az = "a" },
      "pvt_db_b" = { cidr_block = "172.26.11.0/24", az = "b" },
      "pvt_db_c" = { cidr_block = "172.26.12.0/24", az = "c" }
    }
  }
}

variable "ngw_regional_mode" {
  description = "The availability mode regional"
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "The type of instance to use"
  type        = string
  default     = "t3.micro"
}

variable "keypair_name" {
  type    = string
  default = "algadelivery-bastion"
}

variable "ami_id" {
  description = "The ID of the AMI to use for the instance"
  type        = string
  default     = "ami-04680790a315cd58d"
}

variable "bastion_security_group_config" {
  type = object({
    name        = string
    description = string
    ingress_rules = list(object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress_rules = list(object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  })
  default = null
}

# RDS
variable "db_name" {
  description = "The name of the PostgreSQL database"
  type        = string
  default     = "algadelivery"
}

variable "db_username" {
  description = "The username for the PostgreSQL database"
  type        = string
  sensitive   = true
  default     = "algadelivery"
}

variable "db_instance_class" {
  description = "The instance class for the RDS instance"
  type        = string
  default     = "db.t3.medium"
}

variable "db_engine_version" {
  description = "The PostgreSQL engine version"
  type        = string
  default     = "16.3"
}

variable "db_allocated_storage" {
  description = "The amount of storage to allocate (in GB)"
  type        = number
  default     = 100
}

variable "db_multi_az" {
  description = "Whether to deploy a Multi-AZ RDS instance"
  type        = bool
  default     = true
}

variable "db_skip_final_snapshot" {
  description = "Whether to skip the final snapshot when the instance is deleted"
  type        = bool
  default     = false
}

variable "db_parameter_group" {
  description = "Map of PostgreSQL parameter group settings (name = value)"
  type        = map(string)
  default = {
    "max_connections"         = "500"
    "shared_preload_libraries" = "pg_stat_statements,pg_cron,pgaudit"
  }
}

# MSK
variable "msk_kafka_version" {
  description = "The Kafka version to use (e.g., 3.6.0)"
  type        = string
  default     = "3.6.0"
}

variable "msk_number_of_broker_nodes" {
  description = "The number of broker nodes (must equal the number of cluster subnets)"
  type        = number
  default     = 3
}

variable "msk_broker_instance_type" {
  description = "The instance type for MSK brokers (e.g., kafka.t3.small, kafka.m5.large)"
  type        = string
  default     = "kafka.m5.large"
}

variable "msk_broker_volume_size" {
  description = "The size in GiB of the EBS volume for the data drive on each broker node"
  type        = number
  default     = 1000
}

variable "msk_client_broker_encryption" {
  description = "Encryption setting for data in transit between clients and brokers (TLS, PLAINTEXT, TLS_PLAINTEXT)"
  type        = string
  default     = "TLS"
}
