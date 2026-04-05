# Recurso de exemplo para demonstrar operações de state
resource "aws_s3_bucket" "state_demo" {
  bucket = "${var.project_name}-state-demo"
  tags   = { Project = var.project_name, ManagedBy = "OpenTofu" }
}

# Após apply, tente:
#   tofu state list
#   tofu state show aws_s3_bucket.state_demo
#
# Para mover para dentro de um módulo:
#   tofu state mv aws_s3_bucket.state_demo module.storage.aws_s3_bucket.this
