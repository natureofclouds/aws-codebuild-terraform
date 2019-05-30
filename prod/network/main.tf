provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "natureofclouds-terraform"
    key    = "prod/network/terraform.tfstate"
    region = "us-east-1"
  }
}

# external parameter from CodeBuild via TF_VAR_env
variable "env" {} # Name of new environment/vpc

data "aws_vpcs" "vpcs" {}  # Count the number of existing vpcs to calcuate next free /20 cidr_block
locals {
  cidr_block = "${cidrsubnet("172.30.0.0/16", 4, length(data.aws_vpcs.vpcs.ids) - 1)}"
}
