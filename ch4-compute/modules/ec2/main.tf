terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

module "vpc" {
  source = "../vpc"
}

resource "aws_launch_template" "aws_exam_launch_template" {
  instance_type = var.instance_type
  image_id      = "ami-${var.ami_id}"
}

resource "aws_instance" "aws_exam_ec2" {

  subnet_id = module.vpc.subnet_id

  launch_template {
    id = aws_launch_template.aws_exam_launch_template.id
  }

}