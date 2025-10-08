terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

data "aws_vpc" "vpc_default" {
  default = true
}

data "aws_internet_gateway" "default_igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.vpc_default.id]
  }
}

resource "aws_subnet" "subnet_public" {
  cidr_block        = var.subnet_public
  vpc_id            = data.aws_vpc.vpc_default.id
  availability_zone = var.availability_zone
  map_public_ip_on_launch = false
}

resource "aws_route_table_association" "rt_association" {
  route_table_id = data.aws_vpc.vpc_default.main_route_table_id
  subnet_id = aws_subnet.subnet_public.id
}
