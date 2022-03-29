module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.13.0"

  name = "app-vpc-${var.infra_env}"
  cidr = var.vpc_cidr_block

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    "Name"        = "app-vpc-${var.infra_env}"
    "Environment" = var.infra_env
    "Project"     = "Terra"
    "ManagedBy"   = "Terraform"
  }
}
