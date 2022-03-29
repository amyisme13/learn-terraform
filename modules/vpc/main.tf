resource "aws_vpc" "app_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    "Name"        = "app-vpc-${var.infra_env}"
    "Environment" = var.infra_env
    "Project"     = "Terra"
    "ManagedBy"   = "Terraform"
  }
}

resource "aws_subnet" "public" {
  for_each = var.public_subnet_numbers

  vpc_id            = aws_vpc.app_vpc.id
  availability_zone = each.key
  cidr_block        = cidrsubnet(aws_vpc.app_vpc.cidr_block, 4, each.value)

  tags = {
    "Name"        = "app-public-subnet-${var.infra_env}"
    "Environment" = var.infra_env
    "Project"     = "Terra"
    "Role"        = "public"
    "ManagedBy"   = "Terraform"
    "Subnet"      = "${each.key}-${each.value}"
  }
}

resource "aws_subnet" "private" {
  for_each = var.private_subnet_numbers

  vpc_id            = aws_vpc.app_vpc.id
  availability_zone = each.key
  cidr_block        = cidrsubnet(aws_vpc.app_vpc.cidr_block, 4, each.value)

  tags = {
    "Name"        = "app-private-subnet-${var.infra_env}"
    "Environment" = var.infra_env
    "Project"     = "Terra"
    "Role"        = "private"
    "ManagedBy"   = "Terraform"
    "Subnet"      = "${each.key}-${each.value}"
  }
}
