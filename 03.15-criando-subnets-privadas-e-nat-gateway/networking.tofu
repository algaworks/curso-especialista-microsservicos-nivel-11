resource "aws_vpc" "algadelivery" {
  cidr_block = var.vpc_cidr_block
  
  tags = {
    Name = var.vpc_name
    Environment = var.environment
    ManagedBy = "OpenTofu"
  }
}

resource "aws_subnet" "public" {
  for_each          = var.subnet_pub_config
  vpc_id            = aws_vpc.algadelivery.id
  cidr_block        = each.value.cidr_block
  availability_zone = "${var.aws_region}${each.value.az}"

  tags = {
    Name = "${local.context_name}-pub-${each.value.az}"
    Environment = var.environment
    ManagedBy = "OpenTofu"
  }
}

resource "aws_internet_gateway" "algadelivery" {
  vpc_id = aws_vpc.algadelivery.id

  tags = {
    Name = "${local.context_name}-igw"
    Environment = var.environment
    ManagedBy = "OpenTofu"
  }
}

resource "aws_subnet" "private_management" {
  for_each          = var.subnet_pvt_management_config
  vpc_id            = aws_vpc.algadelivery.id
  cidr_block        = each.value.cidr_block
  availability_zone = "${var.aws_region}${each.value.az}"

  tags = {
    Name = "${local.context_name}-pvt-mgmt-${each.value.az}"
    Environment = var.environment
    ManagedBy = "OpenTofu"
  }
}

resource "aws_subnet" "private_cluster" {
  for_each          = var.subnet_pvt_cluster_config
  vpc_id            = aws_vpc.algadelivery.id
  cidr_block        = each.value.cidr_block
  availability_zone = "${var.aws_region}${each.value.az}"

  tags = {
    Name = "${local.context_name}-pvt-cluster-${each.value.az}"
    Environment = var.environment
    ManagedBy = "OpenTofu"

  }
}

resource "aws_nat_gateway" "algadelivery" {
  vpc_id            = aws_vpc.algadelivery.id
  availability_mode = local.ngw_regional_mode

  tags = {
    Name = "${local.context_name}-ngw"
    Environment = var.environment
    ManagedBy = "OpenTofu"
  }
}