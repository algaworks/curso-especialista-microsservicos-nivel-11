locals {
  bucket_name     = "${var.project_name}-tfstate-${var.environment}"
  lock_table_name = "${var.project_name}-tfstate-lock"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "OpenTofu"
  }
}
