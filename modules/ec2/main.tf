resource "random_shuffle" "subnets" {
  result_count = 1
  input        = var.available_subnets
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.5.0"

  name          = "app-vm-${var.infra_env}-${var.infra_role}"
  ami           = var.instance_ami
  instance_type = var.instance_type

  subnet_id              = random_shuffle.subnets.result[0]
  vpc_security_group_ids = var.security_groups

  root_block_device = [
    {
      volume_size = var.instance_root_volume_size
      volume_type = "gp3"
    }
  ]

  tags = merge(
    {
      "Name"        = "app-vm-${var.infra_env}-${var.infra_role}"
      "Environment" = var.infra_env
      "Role"        = var.infra_role
      "Project"     = "Terra"
      "ManagedBy"   = "Terraform"
    },
    var.tags
  )
}

resource "aws_eip" "app_eip" {
  count = (var.create_eip) ? 1 : 0

  vpc = true

  tags = {
    "Name"        = "app-eip-${var.infra_env}-${var.infra_role}"
    "Environment" = var.infra_env
    "Role"        = var.infra_role
    "Project"     = "Terra"
    "ManagedBy"   = "Terraform"
  }
}

resource "aws_eip_association" "app_eip_assoc" {
  count = (var.create_eip) ? 1 : 0

  instance_id   = module.ec2_instance.id
  allocation_id = aws_eip.app_eip[0].id
}
