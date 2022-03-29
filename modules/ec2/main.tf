resource "aws_instance" "app_vm" {
  ami           = var.instance_ami
  instance_type = var.instance_type

  root_block_device {
    volume_size = var.instance_root_volume_size
    volume_type = "gp3"
  }

  tags = {
    "Name"        = "app-vm-${var.infra_env}"
    "Environment" = var.infra_env
    "Role"        = var.infra_role
    "Project"     = "Terra"
    "ManagedBy"   = "Terraform"
  }
}

resource "aws_eip" "app_eip" {
  vpc = true

  tags = {
    "Name"        = "app-eip-${var.infra_env}"
    "Environment" = var.infra_env
    "Role"        = var.infra_role
    "Project"     = "Terra"
    "ManagedBy"   = "Terraform"
  }
}

resource "aws_eip_association" "app_eip_assoc" {
  instance_id   = aws_instance.app_vm.id
  allocation_id = aws_eip.app_eip.id
}
