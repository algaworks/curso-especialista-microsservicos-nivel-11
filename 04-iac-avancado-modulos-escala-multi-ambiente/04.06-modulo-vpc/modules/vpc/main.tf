locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "OpenTofu"
  }
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(local.common_tags, { Name = "${var.project_name}-vpc" })
}

resource "aws_subnet" "public" {
  for_each = var.public_subnet_cidrs

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = "${var.aws_region}${each.key}"
  map_public_ip_on_launch = true
  tags                    = merge(local.common_tags, { Name = "subnet-pub-${each.key}", Tier = "public" })
}

resource "aws_subnet" "management" {
  for_each = var.management_subnet_cidrs

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = "${var.aws_region}${each.key}"
  tags              = merge(local.common_tags, { Name = "subnet-management-${each.key}", Tier = "private" })
}

resource "aws_subnet" "cluster" {
  for_each = var.cluster_subnet_cidrs

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = "${var.aws_region}${each.key}"
  tags              = merge(local.common_tags, { Name = "subnet-cluster-${each.key}", Tier = "private" })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.common_tags, { Name = "${var.project_name}-igw" })
}

resource "aws_eip" "nat" {
  domain     = "vpc"
  tags       = merge(local.common_tags, { Name = "${var.project_name}-nat-eip" })
  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public["a"].id
  tags          = merge(local.common_tags, { Name = "${var.project_name}-nat" })
  depends_on    = [aws_internet_gateway.this]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = merge(local.common_tags, { Name = "${var.project_name}-rt-public" })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
  tags = merge(local.common_tags, { Name = "${var.project_name}-rt-private" })
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "management" {
  for_each       = aws_subnet.management
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "cluster" {
  for_each       = aws_subnet.cluster
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
