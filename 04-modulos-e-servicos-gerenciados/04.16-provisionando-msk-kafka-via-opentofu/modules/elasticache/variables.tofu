variable "context_name" { type = string }
variable "vpc_id" { type = string }
variable "vpc_cidr_block" { type = string }
variable "subnet_ids" { type = list(string) }
variable "node_type" { type = string, default = "cache.t3.micro" }
variable "num_cache_clusters" { type = number, default = 2 }
variable "engine_version" { type = string, default = "7.2" }
variable "common_tags" { type = map(string), default = {} }
