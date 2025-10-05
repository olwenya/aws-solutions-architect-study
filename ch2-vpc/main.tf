terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
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

module "vpc" {
  source = "./modules/vpc"

  count = length(var.vpc_names)

  vpc_name          = var.vpc_names[count.index]
  subnet_private    = var.subnet_private[count.index]
  subnet_public     = var.subnet_public[count.index]
  vpc_cidr          = var.vcp_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

resource "aws_vpc_peering_connection" "aws_exam_vpc_peering" {
  vpc_id      = module.vpc[0].vpc_id
  peer_vpc_id = module.vpc[1].vpc_id
}