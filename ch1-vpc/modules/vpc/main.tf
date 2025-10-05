
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

resource "aws_vpc" "aws_exam_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    "Name" = var.vpc_name
  }
}

resource "aws_subnet" "aws_exam_subnet_private" {
  vpc_id            = aws_vpc.aws_exam_vpc.id
  cidr_block        = var.subnet_private
  availability_zone = var.availability_zone

  tags = {
    "Name" = "${var.vpc_name}_private"
  }
}

resource "aws_subnet" "aws_exam_subnet_public" {
  vpc_id            = aws_vpc.aws_exam_vpc.id
  cidr_block        = var.subnet_public
  availability_zone = var.availability_zone

  tags = {
    "Name" = "${var.vpc_name}_public"
  }
}

resource "aws_internet_gateway" "aws_exam_igw" {
  vpc_id = aws_vpc.aws_exam_vpc.id

  tags = {
    "Name" = "${var.vpc_name}_igw"
  }

}

resource "aws_eip" "aws_exam_nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "aws_exam_nat_gtw" {
  allocation_id = aws_eip.aws_exam_nat_eip.id
  subnet_id     = aws_subnet.aws_exam_subnet_public.id

  tags = {
    "Name" = "${var.vpc_name}_nat"
  }
}

resource "aws_route" "aws_exam_route_igw" {
  route_table_id         = aws_vpc.aws_exam_vpc.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aws_exam_igw.id

}

resource "aws_route_table" "aws_exam_route_table_private" {
  vpc_id = aws_vpc.aws_exam_vpc.id

  tags = {
    "Name" = "${var.vpc_name}_rt"
  }
}

resource "aws_route" "aws_exam_route_nat" {
  route_table_id         = aws_route_table.aws_exam_route_table_private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.aws_exam_nat_gtw.id
}

resource "aws_route_table_association" "private_subnet_association" {
  route_table_id = aws_route_table.aws_exam_route_table_private.id
  subnet_id      = aws_subnet.aws_exam_subnet_private.id

}