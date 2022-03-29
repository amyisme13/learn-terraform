resource "random_shuffle" "subnets" {
  result_count = 1
  input        = var.available_subnets
}

resource "aws_instance" "app_vm" {
  ami           = var.instance_ami
  instance_type = var.instance_type

  root_block_device {
    volume_size = var.instance_root_volume_size
    volume_type = "gp3"
  }

  subnet_id = random_shuffle.subnets.result[0]

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

  instance_id   = aws_instance.app_vm.id
  allocation_id = aws_eip.app_eip[0].id
}
