terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.8.0"
    }
  }

  backend "s3" {
    region = "ap-southeast-3"
    bucket = "terraform-state-amy"
    key    = "app/terraform.tfstate"
  }
}

provider "aws" {
  region = "ap-southeast-3"
}

variable "app_env" {
  type        = string
  description = "The environment of the app"
  default     = "dev"
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

module "vpc" {
  source = "./modules/vpc"

  infra_env      = var.app_env
  vpc_cidr_block = "10.1.0.0/16"
}
module "ec2_web" {
  source = "./modules/ec2"

  infra_env    = var.app_env
  infra_role   = "web"
  instance_ami = data.aws_ami.ubuntu.id
}
