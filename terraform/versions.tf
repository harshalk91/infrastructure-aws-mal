terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
#  backend "s3" {
#    bucket = "terraform-remote-states"
#    key = "path/to/key"
#    region = "me-central-1"
#  }
}


provider "aws" {
  region = var.aws_region
#  assume_role {
#    role_arn     = "arn:aws:iam::<account-id>>:role/terraform-admin"
#    session_name = "terraform"
#  }
}