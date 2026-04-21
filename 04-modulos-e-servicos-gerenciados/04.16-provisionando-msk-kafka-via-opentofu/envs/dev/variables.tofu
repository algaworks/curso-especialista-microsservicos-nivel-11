variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "keypair_name" {
  type    = string
  default = "algadelivery-keypair"
}

variable "db_password" {
  type      = string
  sensitive = true
  default   = ""
}
