locals {
  # terraform.workspace retorna o nome do workspace atual
  # (default, dev, prod, etc.)
  environment = terraform.workspace

  instance_type = terraform.workspace == "prod" ? "t3.small" : "t3.micro"

  common_tags = {
    Project     = var.project_name
    Environment = local.environment
    ManagedBy   = "OpenTofu"
  }
}

# ---------------------------------------------------------
# Aula 36: Workspaces
#
# Commandos:
#   tofu workspace list          → listar workspaces
#   tofu workspace new dev       → criar workspace "dev"
#   tofu workspace select prod   → mudar para "prod"
#   tofu workspace show          → mostrar workspace atual
#
# O estado de cada workspace é isolado no backend S3:
#   algadelivery-tfstate-dev/env:/dev/workspaces/terraform.tfstate
#
# Diferença principal da abordagem multi-env com pastas:
#   Workspaces compartilham o mesmo código, mas isolam estados.
#   Abordagem de pastas (aula-35) oferece maior isolamento.
# ---------------------------------------------------------

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

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.instance_type
  key_name      = var.key_name

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${local.environment}-example"
  })
}

output "workspace" { value = terraform.workspace }
output "instance_type" { value = aws_instance.example.instance_type }
