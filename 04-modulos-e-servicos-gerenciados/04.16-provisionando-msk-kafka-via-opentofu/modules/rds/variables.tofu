variable "context_name" { type = string }
variable "vpc_id" { type = string }
variable "vpc_cidr_block" { type = string }
variable "subnet_ids" { type = list(string) }
variable "db_name" { type = string, default = "algadelivery" }
variable "db_username" { type = string, default = "postgres" }
variable "db_password" { type = string, sensitive = true }
variable "db_instance_class" { type = string, default = "db.t3.micro" }
variable "engine_version" { type = string, default = "16.3" }
variable "engine_major_version" { type = string, default = "16" }
variable "allocated_storage" { type = number, default = 20 }
variable "common_tags" { type = map(string), default = {} }
