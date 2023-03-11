terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.56.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.1"
    }
    shell = {
      source  = "scottwinkler/shell"
      version = "1.7.10"
    }
  }
}

provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      Environment = "Experimental"
      Project     = "EKS-Demo"
      Provisioenr = "Terraform"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
  registry_auth {
    address  = local.aws_ecr_url
    username = data.aws_ecr_authorization_token.eks_demo.user_name
    password = data.aws_ecr_authorization_token.eks_demo.password
  }
}