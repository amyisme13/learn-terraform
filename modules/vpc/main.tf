module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.13.0"

  name = "terra-vpc-${var.infra_env}"
  cidr = var.vpc_cidr_block

  azs = var.azs

  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    "Name"        = "terra-vpc-${var.infra_env}"
    "Environment" = var.infra_env
    "Project"     = "Terra"
    "ManagedBy"   = "Terraform"
  }

  public_subnet_tags = {
    "Name" = "terra-subnet-${var.infra_env}"
    "Role" = "public"
  }

  private_subnet_tags = {
    "Name" = "terra-subnet-${var.infra_env}"
    "Role" = "private"
  }

  database_subnet_tags = {
    "Name" = "terra-subnet-${var.infra_env}"
    "Role" = "database"
  }
}
