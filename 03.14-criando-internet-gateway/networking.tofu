resource "aws_vpc" "algadelivery" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
  for_each          = var.subnet_pub_config
  vpc_id            = aws_vpc.algadelivery.id
  cidr_block        = each.value.cidr_block
  availability_zone = "${var.aws_region}${each.value.az}"

  tags = {
    Name = "${local.context_name}-pub-${each.value.az}"
  }
}

resource "aws_internet_gateway" "algadelivery" {
  vpc_id = aws_vpc.algadelivery.id

  tags = {
    Name = "${local.context_name}-igw"
  }
  
}