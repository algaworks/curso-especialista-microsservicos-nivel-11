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
resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = merge(local.common_tags, { Name = "${var.project_name}-nat-eip" })
}
resource "aws_nat_gateway" "algadelivery" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.pub_a.id
  tags          = merge(local.common_tags, { Name = "${var.project_name}-nat" })
  depends_on    = [aws_internet_gateway.algadelivery]
}
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

# ---------------------------------------------------
# Associações: subnets públicas → route table pública
# ---------------------------------------------------
resource "aws_route_table_association" "pub_a" {
  subnet_id      = aws_subnet.pub_a.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "pub_b" {
  subnet_id      = aws_subnet.pub_b.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "pub_c" {
  subnet_id      = aws_subnet.pub_c.id
  route_table_id = aws_route_table.public.id
}

# ---------------------------------------------------
# Associações: subnets privadas → route table privada
# ---------------------------------------------------
resource "aws_route_table_association" "management_a" {
  subnet_id      = aws_subnet.management_a.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "management_b" {
  subnet_id      = aws_subnet.management_b.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "management_c" {
  subnet_id      = aws_subnet.management_c.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "cluster_a" {
  subnet_id      = aws_subnet.cluster_a.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "cluster_b" {
  subnet_id      = aws_subnet.cluster_b.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "cluster_c" {
  subnet_id      = aws_subnet.cluster_c.id
  route_table_id = aws_route_table.private.id
}
