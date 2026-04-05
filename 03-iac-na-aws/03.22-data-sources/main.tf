# =========================================================================
# NOVO: Data Sources
# =========================================================================

# Busca as AZs disponíveis na região dinamicamente
# Substitui o uso hardcodado de "${var.aws_region}a", "${var.aws_region}b"...
data "aws_availability_zones" "available" {
  state = "available"
}

# Busca a AMI mais recente do Ubuntu 22.04 LTS automaticamente
# Sem precisar hardcodar o ID da AMI (que muda por região e versão)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# ---- código anterior: VPC -----------------------------------------------
resource "aws_vpc" "algadelivery" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(local.common_tags, { Name = "${var.project_name}-vpc" })
}

# ---- código anterior: Subnets (agora usando AZs via data source) ---------
resource "aws_subnet" "public" {
  for_each                = var.public_subnet_cidrs
  vpc_id                  = aws_vpc.algadelivery.id
  cidr_block              = each.value
  availability_zone       = local.az_by_suffix[each.key]
  map_public_ip_on_launch = true
  tags                    = merge(local.common_tags, { Name = "subnet-pub-${each.key}", Tier = "public" })
}

resource "aws_subnet" "management" {
  for_each          = var.management_subnet_cidrs
  vpc_id            = aws_vpc.algadelivery.id
  cidr_block        = each.value
  availability_zone = local.az_by_suffix[each.key]
  tags              = merge(local.common_tags, { Name = "subnet-management-${each.key}", Tier = "private" })
}

resource "aws_subnet" "cluster" {
  for_each          = var.cluster_subnet_cidrs
  vpc_id            = aws_vpc.algadelivery.id
  cidr_block        = each.value
  availability_zone = local.az_by_suffix[each.key]
  tags              = merge(local.common_tags, { Name = "subnet-cluster-${each.key}", Tier = "private" })
}

# ---- código anterior: Internet Gateway -----------------------------------
resource "aws_internet_gateway" "algadelivery" {
  vpc_id = aws_vpc.algadelivery.id
  tags   = merge(local.common_tags, { Name = "${var.project_name}-igw" })
}

# ---- código anterior: NAT Gateway ----------------------------------------
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

# ---- código anterior: Route Tables ---------------------------------------
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

# ---- código anterior: Associações ----------------------------------------
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

# ---- código anterior: Security Groups ------------------------------------
resource "aws_security_group" "bastion" {
  name        = "${var.project_name}-sg-bastion"
  description = "Security group do Bastion Host"
  vpc_id      = aws_vpc.algadelivery.id

  ingress {
    description = "SSH da internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    description = "Trafego de saida liberado"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-sg-bastion" })
}

resource "aws_security_group" "private" {
  name        = "${var.project_name}-sg-private"
  description = "Security group para instancias privadas"
  vpc_id      = aws_vpc.algadelivery.id

  ingress {
    description     = "SSH a partir do Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    description = "Trafego de saida liberado"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-sg-private" })
}
