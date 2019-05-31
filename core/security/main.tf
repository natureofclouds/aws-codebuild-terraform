provider "aws" {
  region = "us-east-1"
}

# Would like to use variables in the key but the terraform.backend configuration cannot contain interpolations 
# Alternative would be generate the Terraform code via Jinja templates perhaps...
terraform {
  backend "s3" {
    bucket = "natureofclouds-terraform"
    key    = "core/security/terraform.tfstate"
    region = "us-east-1"
  }
}

# external parameter from CodeBuild via TF_VAR_env
variable "env" {} # Name of new environment/vpc
