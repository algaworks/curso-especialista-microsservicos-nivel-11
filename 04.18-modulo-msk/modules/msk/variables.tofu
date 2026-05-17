variable "cluster_name" {
  description = "The name of the MSK cluster"
  type        = string
}

variable "kafka_version" {
  description = "The Kafka version to use (e.g., 3.6.0)"
  type        = string
  default     = "3.6.0"
}

variable "number_of_broker_nodes" {
  description = "The number of broker nodes (must equal the number of subnets provided)"
  type        = number
  default     = 3
}

variable "broker_instance_type" {
  description = "The instance type for MSK brokers (e.g., kafka.t3.small, kafka.m5.large)"
  type        = string
  default     = "kafka.t3.small"
}

variable "broker_volume_size" {
  description = "The size in GiB of the EBS volume for the data drive on each broker node"
  type        = number
  default     = 100
}

variable "client_broker_encryption" {
  description = "Encryption setting for data in transit between clients and brokers (TLS, PLAINTEXT, TLS_PLAINTEXT)"
  type        = string
  default     = "TLS_PLAINTEXT"

  validation {
    condition     = contains(["TLS", "PLAINTEXT", "TLS_PLAINTEXT"], var.client_broker_encryption)
    error_message = "client_broker_encryption must be TLS, PLAINTEXT, or TLS_PLAINTEXT."
  }
}

variable "subnet_ids" {
  description = "List of subnet IDs for the MSK brokers (one per AZ, count must equal number_of_broker_nodes)"
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block of the VPC"
  type        = string
}

variable "security_group_name" {
  description = "Name for the MSK security group"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}
