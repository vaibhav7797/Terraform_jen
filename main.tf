provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "clouddrove-secure-bucket-new-version-terraform"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}


module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "0.15.1"

  name        = "moneyceo"
  environment = var.environment
  label_order = var.label_order
  cidr_block  = var.vpc_cidr_block
}

module "subnets" {
  source  = "clouddrove/subnet/aws"
  version = "0.15.3"

  name        = "moneyceo"
  environment = var.environment
  label_order = var.label_order

  nat_gateway_enabled = true
  single_nat_gateway  = true

  availability_zones              = var.availability_zones
  vpc_id                          = module.vpc.vpc_id
  type                            = var.type
  igw_id                          = module.vpc.igw_id
  cidr_block                      = module.vpc.vpc_cidr_block
  ipv6_cidr_block                 = module.vpc.ipv6_cidr_block
  assign_ipv6_address_on_creation = var.assign_ipv6_address_on_creation
}