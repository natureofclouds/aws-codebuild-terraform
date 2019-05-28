provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "natureofclouds-terraform"
    key    = "${var.env}/${var.component}/terraform.tfstate"
    region = "us-east-1"
  }
}

# external parameter from CodeBuild via TF_VAR_env
variable "env" {} # Name of new environment/vpc
variable "component" {} # Name of component directory

resource "aws_codebuild_project" "terraform-apply" {
  name          = "terraform-apply"
  build_timeout = "1"
  service_role  = "${aws_iam_role.example.arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

 cache {
    type     = "S3"
    location = "natureofclouds-codebuild-cache"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/ubuntu-base:14.04"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      "name"  = "cmd"
      "value" = "apply"
    }
    environment_variable {
      "name"  = "env"
      "value" = "prod"
    }
    environment_variable {
      "name"  = "component"
      "value" = "network"
    }
    environment_variable {
      "name"  = "options"
      "value" = "-input=false -auto-approve"
    }

  }
  source {
    type            = "GITHUB"
    location        = "https://github.com/natureofclouds/aws-codebuild-terraform.git"
    git_clone_depth = 1
  }
}
