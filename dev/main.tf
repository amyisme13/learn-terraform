terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.8.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.2"
    }
  }

  backend "s3" {
    region = "ap-southeast-3"
  }
}

provider "aws" {
  region = "ap-southeast-3"
}

variable "app_env" {
  type        = string
  description = "The environment of the application"
  default     = "dev"
}

locals {
  subnets = cidrsubnets("10.1.0.0/16", 4, 4, 4, 4, 4, 4)
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

module "ec2_web" {
  source = "../modules/ec2"

  infra_env    = var.app_env
  infra_role   = "web"
  instance_ami = data.aws_ami.ubuntu.id

  available_subnets = module.vpc.public_subnets
  security_groups   = [module.vpc.security_group_public]
}

module "ec2_worker" {
  source = "../modules/ec2"

  infra_env    = var.app_env
  infra_role   = "worker"
  instance_ami = data.aws_ami.ubuntu.id

  available_subnets = module.vpc.private_subnets
  security_groups   = [module.vpc.security_group_private]

  create_eip = false

  tags = {
    "Name" = "app-worker-${var.app_env}"
  }
}

module "vpc" {
  source = "../modules/vpc"

  infra_env      = var.app_env
  vpc_cidr_block = "10.1.0.0/16"

  azs             = ["ap-southeast-3a", "ap-southeast-3b", "ap-southeast-3c"]
  public_subnets  = slice(local.subnets, 0, 3)
  private_subnets = slice(local.subnets, 3, 6)
}
