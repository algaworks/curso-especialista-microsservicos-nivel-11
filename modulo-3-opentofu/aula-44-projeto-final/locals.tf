locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "OpenTofu"
  }

  bastion_instance_type = var.environment == "prod" ? "t3.small" : "t3.micro"
  private_instance_type = var.environment == "prod" ? "t3.medium" : "t3.micro"
}
