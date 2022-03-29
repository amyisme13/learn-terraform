output "app_ip" {
  value = aws_eip.app_eip.*.public_ip
}

output "app_instance" {
  value = module.ec2_instance.id
}
