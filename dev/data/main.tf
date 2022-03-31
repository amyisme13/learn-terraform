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

variable "db_password" {
  type        = string
  description = "Database default master password"
}

data "aws_vpc" "vpc" {
  tags = {
    "Name"        = "terra-vpc-${var.infra_env}"
    "Environment" = var.infra_env
    "Project"     = "Terra"
    "ManagedBy"   = "Terraform"
  }
}

data "aws_subnets" "database_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  tags = {
    "Name"        = "terra-subnet-${var.infra_env}"
    "Environment" = var.infra_env
    "Project"     = "Terra"
    "Role"        = "database"
    "ManagedBy"   = "Terraform"
  }
}

module "database_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name   = "app-sg-${var.infra_env}-db"
  vpc_id = data.aws_vpc.vpc.id

  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL access from within VPC"
      cidr_blocks = data.aws_vpc.vpc.cidr_block
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "tcp"
      description = "MySQL out to VPC"
      cidr_blocks = data.aws_vpc.vpc.cidr_block
    },
  ]

  tags = {
    "Name"        = "app-sg-${var.infra_env}-db"
    "Environment" = var.infra_env
    "Role"        = "database"
    "Project"     = "Terra"
    "ManagedBy"   = "Terraform"
  }
}

module "database" {
  source = "../../modules/rds"

  infra_env = var.infra_env

  security_groups = [module.database_sg.security_group_id]
  subnets         = data.aws_subnets.database_subnets.ids

  master_password = var.db_password
}
