locals {
  azs = ["a", "b", "c"]

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "OpenTofu"
  }
}
