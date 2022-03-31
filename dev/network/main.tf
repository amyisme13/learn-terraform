terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.8.0"
    }
  }

  backend "s3" {
    region = "ap-southeast-3"
  }
}

provider "aws" {
  region = "ap-southeast-3"
}

variable "infra_env" {
  type        = string
  description = "The environment of the application"
  default     = "dev"
}

locals {
  subnets = cidrsubnets("10.1.0.0/16", 4, 4, 4, 4, 4, 4, 4, 4, 4)
}

module "vpc" {
  source = "../../modules/vpc"

  infra_env      = var.infra_env
  vpc_cidr_block = "10.1.0.0/16"

  azs = ["ap-southeast-3a", "ap-southeast-3b", "ap-southeast-3c"]

  public_subnets   = slice(local.subnets, 0, 3)
  private_subnets  = slice(local.subnets, 3, 6)
  database_subnets = slice(local.subnets, 6, 9)
}
