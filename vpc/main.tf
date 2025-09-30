terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "aws_exam_vpc" {
  count = length(var.vcp_cidrs)
  cidr_block = var.vcp_cidrs[count.index]

  tags = {
    "Name": "AWSExamVPC${count.index}"
  }
  
}

resource "aws_subnet" "aws_examp_subnets_private" {
  count = length(var.subnet_private)
  vpc_id = aws_vpc.aws_exam_vpc[count.index].id
  cidr_block = element(var.subnet_private, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    "Name" = "AWSExam-Subnet-Private-${count.index}"
    "visibility" = "private"
  }
}

resource "aws_subnet" "aws_exam_subnets_public" {
  count = length(var.subnet_public)
  vpc_id = aws_vpc.aws_exam_vpc[count.index].id
  cidr_block = element(var.subnet_public, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    "Name" = "AWSExam-Subnet-Public-${count.index}"
    "visibility" = "public"
  }
}


resource "aws_internet_gateway" "aws_exam_igw" {
  count = length(var.vcp_cidrs)
  vpc_id = aws_vpc.aws_exam_vpc[count.index].id
  tags = {
    "Name" = "AWSExam-IGW${count.index}"
  }
}

resource "aws_eip" "aws_exam_nat_eip" {
  count = length(aws_vpc.aws_exam_vpc)
  domain = "vpc"
}

resource "aws_nat_gateway" "aws_exam_nat_gtw" {
  count = length(aws_subnet.aws_exam_subnets_public)
  allocation_id = aws_eip.aws_exam_nat_eip[count.index].id
  subnet_id = aws_subnet.aws_exam_subnets_public[count.index].id

  tags = {
    "Name": "AWSExam-NAT-${count.index}"
  }
}