terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.8.0"
    }
  }

  backend "s3" {
    region = "ap-southeast-3"
    bucket = "terraform-state-amy"
    key    = "app/terraform.tfstate"
  }
}

provider "aws" {
  region = "ap-southeast-3"
}

data "aws_ami" "ubuntu_ami" {
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

resource "aws_instance" "web_app" {
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.instance_type

  root_block_device {
    volume_size = "20"
  }

  tags = {
    "Name"        = "web-app-${var.app_env}"
    "Environment" = var.app_env
    "Project"     = "Terra"
    "ManagedBy"   = "Terraform"
  }
}

resource "aws_eip" "app_eip" {
  vpc = true

  tags = {
    "Name"        = "app-eip-${var.app_env}"
    "Environment" = var.app_env
    "Project"     = "Terra"
    "ManagedBy"   = "Terraform"
  }
}

resource "aws_eip_association" "app_eip_assoc" {
  instance_id   = aws_instance.web_app.id
  allocation_id = aws_eip.app_eip.id
}
