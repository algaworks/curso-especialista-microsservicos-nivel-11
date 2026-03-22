# VPC
resource "aws_vpc" "algadelivery" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(local.common_tags, { Name = "${var.project_name}-vpc" })
}

# Subnets Públicas
resource "aws_subnet" "public" {
  for_each = var.public_subnet_cidrs

  vpc_id                  = aws_vpc.algadelivery.id
  cidr_block              = each.value
  availability_zone       = "${var.aws_region}${each.key}"
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "subnet-pub-${each.key}"
    Tier = "public"
  })
}

# Subnets de Management
resource "aws_subnet" "management" {
  for_each = var.management_subnet_cidrs

  vpc_id            = aws_vpc.algadelivery.id
  cidr_block        = each.value
  availability_zone = "${var.aws_region}${each.key}"

  tags = merge(local.common_tags, {
    Name = "subnet-management-${each.key}"
    Tier = "private"
  })
}

# Subnets de Cluster
resource "aws_subnet" "cluster" {
  for_each = var.cluster_subnet_cidrs

  vpc_id            = aws_vpc.algadelivery.id
  cidr_block        = each.value
  availability_zone = "${var.aws_region}${each.key}"

  tags = merge(local.common_tags, {
    Name = "subnet-cluster-${each.key}"
    Tier = "private"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "algadelivery" {
  vpc_id = aws_vpc.algadelivery.id
  tags   = merge(local.common_tags, { Name = "${var.project_name}-igw" })
}

# Elastic IP + NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = merge(local.common_tags, { Name = "${var.project_name}-nat-eip" })
}

resource "aws_nat_gateway" "algadelivery" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public["a"].id
  tags          = merge(local.common_tags, { Name = "${var.project_name}-nat" })
  depends_on    = [aws_internet_gateway.algadelivery]
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.algadelivery.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.algadelivery.id
  }
  tags = merge(local.common_tags, { Name = "${var.project_name}-rt-public" })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.algadelivery.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.algadelivery.id
  }
  tags = merge(local.common_tags, { Name = "${var.project_name}-rt-private" })
}

# Associações — subnets públicas
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Associações — subnets de management
resource "aws_route_table_association" "management" {
  for_each       = aws_subnet.management
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

# Associações — subnets de cluster
resource "aws_route_table_association" "cluster" {
  for_each       = aws_subnet.cluster
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
