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

module "s3" {
  source          = "./modules/s3"
  index_page_path = "./index.html"
}

output "website_url" {
  value = module.s3.website_url
}