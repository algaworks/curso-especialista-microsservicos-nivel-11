# VPC
resource "aws_vpc" "algadelivery" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(local.common_tags, { Name = "${var.project_name}-vpc" })
}

# Subnets
resource "aws_subnet" "public" {
  for_each                = local.public_subnet_cidrs
  vpc_id                  = aws_vpc.algadelivery.id
  cidr_block              = each.value
  availability_zone       = local.az_by_suffix[each.key]
  map_public_ip_on_launch = true
  tags                    = merge(local.common_tags, { Name = "subnet-pub-${each.key}", Tier = "public" })
}

resource "aws_subnet" "management" {
  for_each          = local.management_subnet_cidrs
  vpc_id            = aws_vpc.algadelivery.id
  cidr_block        = each.value
  availability_zone = local.az_by_suffix[each.key]
  tags              = merge(local.common_tags, { Name = "subnet-management-${each.key}", Tier = "private" })
}

resource "aws_subnet" "cluster" {
  for_each          = local.cluster_subnet_cidrs
  vpc_id            = aws_vpc.algadelivery.id
  cidr_block        = each.value
  availability_zone = local.az_by_suffix[each.key]
  tags              = merge(local.common_tags, { Name = "subnet-cluster-${each.key}", Tier = "private" })
}

# Internet Gateway
resource "aws_internet_gateway" "algadelivery" {
  vpc_id = aws_vpc.algadelivery.id
  tags   = merge(local.common_tags, { Name = "${var.project_name}-igw" })
}

# NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = merge(local.common_tags, { Name = "${var.project_name}-nat-eip" })
  
}

resource "aws_nat_gateway" "algadelivery" {
  allocation_id     = aws_eip.nat.id
  availability_mode = "regional"
  vpc_id            = aws_vpc.algadelivery.id
  tags              = merge(local.common_tags, { Name = "${var.project_name}-nat" })
  depends_on        = [aws_internet_gateway.algadelivery]
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.algadelivery.id
  route {
    cidr_block = local.all_traffic_cidr
    gateway_id = aws_internet_gateway.algadelivery.id
  }
  tags = merge(local.common_tags, { Name = "${var.project_name}-rt-public" })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.algadelivery.id
  route {
    cidr_block     = local.all_traffic_cidr
    nat_gateway_id = aws_nat_gateway.algadelivery.id
  }
  tags = merge(local.common_tags, { Name = "${var.project_name}-rt-private" })
}

# Route Table Associations
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
