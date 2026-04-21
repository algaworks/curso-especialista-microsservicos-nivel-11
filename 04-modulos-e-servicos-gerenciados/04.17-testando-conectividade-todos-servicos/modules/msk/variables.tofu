variable "context_name" { type = string }
variable "cluster_name" { type = string; default = "kafka" }
variable "vpc_id" { type = string }
variable "vpc_cidr_block" { type = string }
variable "subnet_ids" { type = list(string) }
variable "kafka_version" { type = string; default = "3.5.1" }
variable "broker_instance_type" { type = string; default = "kafka.t3.small" }
variable "ebs_volume_size" { type = number; default = 20 }
variable "common_tags" { type = map(string); default = {} }
