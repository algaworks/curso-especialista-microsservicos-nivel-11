resource "aws_vpc" "algadelivery" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(local.common_tags, { Name = "${var.project_name}-vpc" })
}

resource "aws_subnet" "pub_a" {
  vpc_id                  = aws_vpc.algadelivery.id
  cidr_block              = "172.31.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags                    = merge(local.common_tags, { Name = "subnet-pub-a", Tier = "public" })
}
resource "aws_subnet" "pub_b" {
  vpc_id                  = aws_vpc.algadelivery.id
  cidr_block              = "172.31.2.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true
  tags                    = merge(local.common_tags, { Name = "subnet-pub-b", Tier = "public" })
}
resource "aws_subnet" "pub_c" {
  vpc_id                  = aws_vpc.algadelivery.id
  cidr_block              = "172.31.3.0/24"
  availability_zone       = "${var.aws_region}c"
  map_public_ip_on_launch = true
  tags                    = merge(local.common_tags, { Name = "subnet-pub-c", Tier = "public" })
}

resource "aws_subnet" "management_a" {
  vpc_id            = aws_vpc.algadelivery.id
  cidr_block        = "172.31.4.0/24"
  availability_zone = "${var.aws_region}a"
  tags              = merge(local.common_tags, { Name = "subnet-management-a", Tier = "private" })
}
resource "aws_subnet" "management_b" {
  vpc_id            = aws_vpc.algadelivery.id
  cidr_block        = "172.31.5.0/24"
  availability_zone = "${var.aws_region}b"
  tags              = merge(local.common_tags, { Name = "subnet-management-b", Tier = "private" })
}
resource "aws_subnet" "management_c" {
  vpc_id            = aws_vpc.algadelivery.id
  cidr_block        = "172.31.6.0/24"
  availability_zone = "${var.aws_region}c"
  tags              = merge(local.common_tags, { Name = "subnet-management-c", Tier = "private" })
}

resource "aws_subnet" "cluster_a" {
  vpc_id            = aws_vpc.algadelivery.id
  cidr_block        = "172.31.7.0/24"
  availability_zone = "${var.aws_region}a"
  tags              = merge(local.common_tags, { Name = "subnet-cluster-a", Tier = "private" })
}
resource "aws_subnet" "cluster_b" {
  vpc_id            = aws_vpc.algadelivery.id
  cidr_block        = "172.31.8.0/24"
  availability_zone = "${var.aws_region}b"
  tags              = merge(local.common_tags, { Name = "subnet-cluster-b", Tier = "private" })
}
resource "aws_subnet" "cluster_c" {
  vpc_id            = aws_vpc.algadelivery.id
  cidr_block        = "172.31.9.0/24"
  availability_zone = "${var.aws_region}c"
  tags              = merge(local.common_tags, { Name = "subnet-cluster-c", Tier = "private" })
}

resource "aws_internet_gateway" "algadelivery" {
  vpc_id = aws_vpc.algadelivery.id
  tags   = merge(local.common_tags, { Name = "${var.project_name}-igw" })
}

# Elastic IP para o NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = merge(local.common_tags, { Name = "${var.project_name}-nat-eip" })
}

# NAT Gateway — fica na subnet pública para rotear tráfego das privadas
resource "aws_nat_gateway" "algadelivery" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.pub_a.id

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-nat"
  })

  depends_on = [aws_internet_gateway.algadelivery]
}
