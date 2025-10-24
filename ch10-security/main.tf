terraform {
  required_providers {
    aws = {
      version = "~> 6.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "caller_identity" {}

module "kms_key" {
  source     = "./modules/kms-key"
  caller_arn = data.aws_caller_identity.caller_identity.arn
}