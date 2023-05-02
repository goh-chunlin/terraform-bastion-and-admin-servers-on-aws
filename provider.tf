terraform {
  backend "s3" {
    bucket = "my-terraform-01"
    key    = "test/terraform.tfstate"
    region = "ap-southeast-1"
  }
  required_version = ">=1.1.3"
}

provider "aws" {
  region = var.aws_region
}
