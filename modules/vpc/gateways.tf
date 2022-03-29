# Public
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    "Name"        = "app-igw-${var.infra_env}"
    "Environment" = var.infra_env
    "VPC"         = aws_vpc.app_vpc.id
    "Project"     = "Terra"
    "ManagedBy"   = "Terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name"        = "app-public-rt-${var.infra_env}"
    "Environment" = var.infra_env
    "VPC"         = aws_vpc.app_vpc.id
    "Role"        = "public"
    "Project"     = "Terra"
    "ManagedBy"   = "Terraform"
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

# Private
resource "aws_eip" "ngw_eip" {
  vpc = true

  tags = {
    "Name"        = "app-ngw-eip-${var.infra_env}"
    "Environment" = var.infra_env
    "Role"        = "ngw"
    "Project"     = "Terra"
    "ManagedBy"   = "Terraform"
  }
}

locals {
  first_subnet = aws_subnet.public[element(keys(aws_subnet.public), 0)]
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw_eip.id
  subnet_id     = local.first_subnet.id

  tags = {
    "Name"        = "app-ngw-${var.infra_env}"
    "Environment" = var.infra_env
    "VPC"         = aws_vpc.app_vpc.id
    "Project"     = "Terra"
    "ManagedBy"   = "Terraform"
    "Subnet"      = local.first_subnet.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    "Name"        = "app-private-rt-${var.infra_env}"
    "Environment" = var.infra_env
    "VPC"         = aws_vpc.app_vpc.id
    "Role"        = "private"
    "Project"     = "Terra"
    "ManagedBy"   = "Terraform"
  }
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private.id
}
