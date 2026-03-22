locals {
  bucket_name = "${var.project_name}-tfstate-${var.environment}"

  common_tags = {
    Name        = "${var.project_name}-tfstate"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "OpenTofu"
  }
}
