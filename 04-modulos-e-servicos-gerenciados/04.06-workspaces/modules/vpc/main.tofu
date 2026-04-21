resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block

  tags = merge(var.common_tags, {
    Name = var.vpc_name
  })
}

resource "aws_subnet" "public" {
  for_each          = var.subnet_pub_config
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = "${var.aws_region}${each.value.az}"

  tags = merge(var.common_tags, {
    Name = "${var.context_name}-pub-${each.value.az}"
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.common_tags, {
    Name = "${var.context_name}-igw"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.common_tags, {
    Name = "${var.context_name}-rt-public"
  })
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private_management" {
  for_each          = var.subnet_pvt_management_config
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = "${var.aws_region}${each.value.az}"

  tags = merge(var.common_tags, {
    Name = "${var.context_name}-pvt-mgmt-${each.value.az}"
  })
}

resource "aws_subnet" "private_cluster" {
  for_each          = var.subnet_pvt_cluster_config
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = "${var.aws_region}${each.value.az}"

  tags = merge(var.common_tags, {
    Name = "${var.context_name}-pvt-cluster-${each.value.az}"
  })
}

resource "aws_nat_gateway" "this" {
  vpc_id            = aws_vpc.this.id
  availability_mode = var.ngw_regional_mode ? "regional" : "zonal"

  tags = merge(var.common_tags, {
    Name = "${var.context_name}-ngw"
  })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = merge(var.common_tags, {
    Name = "${var.context_name}-rt-private"
  })
}

resource "aws_route_table_association" "private_management" {
  for_each       = aws_subnet.private_management
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_cluster" {
  for_each       = aws_subnet.private_cluster
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
