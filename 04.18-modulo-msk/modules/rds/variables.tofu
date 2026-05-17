variable "db_identifier" {
  description = "The identifier for the RDS instance"
  type        = string
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "db_username" {
  description = "The username for the database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  ephemeral   = true
}

variable "engine_version" {
  description = "The version of PostgreSQL to use"
  type        = string
  default     = "16.3"
}

variable "instance_class" {
  description = "The instance class for the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "The amount of storage to allocate (in GB)"
  type        = number
  default     = 20
}

variable "multi_az" {
  description = "Whether to deploy a Multi-AZ RDS instance"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot when the instance is deleted"
  type        = bool
  default     = true
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group"
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

variable "db_subnet_group_name" {
  description = "Name for the DB subnet group"
  type        = string
}

variable "db_parameter_group_name" {
  description = "Name for the DB parameter group"
  type        = string
}

variable "security_group_name" {
  description = "Name for the RDS security group"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}
