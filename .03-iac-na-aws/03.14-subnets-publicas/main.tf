resource "aws_vpc" "algadelivery" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-vpc"
  })
}

# Subnets Públicas (us-east-1a, 1b, 1c)
resource "aws_subnet" "pub_a" {
  vpc_id                  = aws_vpc.algadelivery.id
  cidr_block              = "172.31.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "subnet-pub-a"
    Tier = "public"
  })
}

resource "aws_subnet" "pub_b" {
  vpc_id                  = aws_vpc.algadelivery.id
  cidr_block              = "172.31.2.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "subnet-pub-b"
    Tier = "public"
  })
}

resource "aws_subnet" "pub_c" {
  vpc_id                  = aws_vpc.algadelivery.id
  cidr_block              = "172.31.3.0/24"
  availability_zone       = "${var.aws_region}c"
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "subnet-pub-c"
    Tier = "public"
  })
}
