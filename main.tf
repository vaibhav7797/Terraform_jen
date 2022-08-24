provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "clouddrove-secure-bucket-test-private"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "0.15.1"

  name        = "moneyceo"
  environment = "test"
  label_order = ["name","environment"]
  cidr_block  = "10.0.0.0/16"
}
