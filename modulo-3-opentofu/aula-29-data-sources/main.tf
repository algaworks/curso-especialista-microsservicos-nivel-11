# ---------------------------------------------------------
# Aula 29: Data Sources
#
# Data sources buscam informações existentes na AWS
# sem criar recursos — leitura somente.
# ---------------------------------------------------------

# AMI Ubuntu 22.04 mais recente
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Zonas de disponibilidade da região atual
data "aws_availability_zones" "available" {
  state = "available"
}

# Conta AWS atual
data "aws_caller_identity" "current" {}

# Região atual
data "aws_region" "current" {}

# VPC existente por tag (busca uma VPC já criada)
data "aws_vpc" "algadelivery" {
  filter {
    name   = "tag:Project"
    values = [var.project_name]
  }
}

output "ubuntu_ami_id" { value = data.aws_ami.ubuntu.id }
output "available_azs" { value = data.aws_availability_zones.available.names }
output "account_id" { value = data.aws_caller_identity.current.account_id }
output "current_region" { value = data.aws_region.current.name }
output "vpc_id" { value = data.aws_vpc.algadelivery.id }
