# Public security group
resource "aws_security_group" "public" {
  name   = "app-sg-${var.infra_env}-public"
  vpc_id = module.vpc.vpc_id

  tags = {
    "Name"        = "app-sg-${var.infra_env}-public"
    "Environment" = var.infra_env
    "Role"        = "public"
    "Project"     = "Terra"
    "ManagedBy"   = "Terraform"
  }
}

resource "aws_security_group_rule" "public_out" {
  security_group_id = aws_security_group.public.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "public_in_ssh" {
  security_group_id = aws_security_group.public.id

  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "public_in_http" {
  security_group_id = aws_security_group.public.id

  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "public_in_https" {
  security_group_id = aws_security_group.public.id

  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# Private security group
resource "aws_security_group" "private" {
  name   = "app-sg-${var.infra_env}-private"
  vpc_id = module.vpc.vpc_id

  tags = {
    "Name"        = "app-sg-${var.infra_env}-private"
    "Environment" = var.infra_env
    "Role"        = "private"
    "Project"     = "Terra"
    "ManagedBy"   = "Terraform"
  }
}

resource "aws_security_group_rule" "private_out" {
  security_group_id = aws_security_group.private.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "private_in" {
  security_group_id = aws_security_group.private.id

  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "-1"
  cidr_blocks = [module.vpc.vpc_cidr_block]
}
