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

resource "aws_subnet" "subnet_public" {
  cidr_block        = var.subnet_public
  vpc_id            = data.aws_vpc.vpc_default.id
  availability_zone = var.availability_zone
}