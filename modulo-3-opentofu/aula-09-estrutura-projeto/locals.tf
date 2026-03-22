locals {
  bucket_name = "${var.project_name}-tfstate-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "OpenTofu"
  }
}
