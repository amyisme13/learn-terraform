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

data "aws_vpc" "vpc" {
  tags = {
    "Name"        = "terra-vpc-${var.infra_env}"
    "Environment" = var.infra_env
    "Project"     = "Terra"
    "ManagedBy"   = "Terraform"
  }
}

# For public instance
data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  tags = {
    "Name"        = "terra-subnet-${var.infra_env}"
    "Environment" = var.infra_env
    "Project"     = "Terra"
    "Role"        = "public"
    "ManagedBy"   = "Terraform"
  }
}

data "aws_security_groups" "public_sg" {
  tags = {
    "Name"        = "app-sg-${var.infra_env}-public"
    "Environment" = var.infra_env
    "Role"        = "public"
    "Project"     = "Terra"
    "ManagedBy"   = "Terraform"
  }
}

module "ec2_web" {
  source = "../../modules/ec2"

  infra_env    = var.infra_env
  infra_role   = "web"
  instance_ami = data.aws_ami.ubuntu.id

  available_subnets = data.aws_subnets.public_subnets.ids
  security_groups   = data.aws_security_groups.public_sg.ids
}

# For private instance
# data "aws_subnets" "private_subnets" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.vpc.id]
#   }

#   tags = {
#     "Name"        = "terra-subnet-${var.infra_env}"
#     "Environment" = var.infra_env
#     "Project"     = "Terra"
#     "Role"        = "private"
#     "ManagedBy"   = "Terraform"
#   }
# }

# data "aws_security_groups" "private_sg" {
#   tags = {
#     "Name"        = "app-sg-${var.infra_env}-private"
#     "Environment" = var.infra_env
#     "Role"        = "private"
#     "Project"     = "Terra"
#     "ManagedBy"   = "Terraform"
#   }
# }

# module "ec2_worker" {
#   source = "../../modules/ec2"

#   infra_env    = var.infra_env
#   infra_role   = "worker"
#   instance_ami = data.aws_ami.ubuntu.id

#   available_subnets = data.aws_subnets.private_subnets.ids
#   security_groups   = data.aws_security_groups.private_sg.ids

#   create_eip = false

#   tags = {
#     "Name" = "queue-worker-${var.infra_env}"
#   }
# }
