output "app_ip" {
  value = aws_eip.app_eip.*.public_ip
}

output "app_instance" {
  value = aws_instance.app_vm.id
}
