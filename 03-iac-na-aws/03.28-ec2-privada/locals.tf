locals {
  all_traffic_cidr = "0.0.0.0/0"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "OpenTofu"
  }

  az_by_suffix = {
    a = data.aws_availability_zones.available.names[0]
    b = data.aws_availability_zones.available.names[1]
    c = data.aws_availability_zones.available.names[2]
  }
}
