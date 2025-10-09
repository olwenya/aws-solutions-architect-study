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

data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}


resource "aws_launch_template" "aws_exam_launch_template" {
  instance_type = var.instance_type
  image_id      = "ami-${var.ami_id}"
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]
}

resource "aws_autoscaling_group" "asg" {
  launch_template {
    id = aws_launch_template.aws_exam_launch_template.id
  }
  vpc_zone_identifier = [ module.vpc.subnet_id ]

  max_size = 1
  min_size = 1
}

resource "aws_security_group" "ssh_sg" {
  vpc_id = module.vpc.vpc_id

  # SSH inbound rule
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}