resource "aws_vpc" "algadelivery" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.algadelivery.id
  cidr_block        = var.subnet_pub_config[0].cidr_block
  availability_zone = "${var.aws_region}${var.subnet_pub_config[0].az}"

  tags = {
    Name = var.subnet_pub_config[0].name
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.algadelivery.id
  cidr_block        = var.subnet_pub_config[1].cidr_block
  availability_zone = "${var.aws_region}${var.subnet_pub_config[1].az}"

  tags = {
    Name = var.subnet_pub_config[1].name
  }
}

resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.algadelivery.id
  cidr_block        = var.subnet_pub_config[2].cidr_block
  availability_zone = "${var.aws_region}${var.subnet_pub_config[2].az}"

  tags = {
    Name = var.subnet_pub_config[2].name
  }
}