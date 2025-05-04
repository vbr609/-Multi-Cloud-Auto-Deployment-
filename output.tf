#output "ansible_inventory" {
#  value = {
#    azure_vms = [
#      "adminuser@${azurerm_linux_virtual_machine.my_vm.public_ip_address}"
#    ]
#    aws_vms = [
#      "ubuntu@${aws_instance.my_instance.public_ip}"
#    ]
#  }
#}

#output "aws_public_ip" {
#  value = aws_instance.my_instance.public_ip
#}

#output "azure_public_ip" {
#  value = azurerm_linux_virtual_machine.my_vm.public_ip_address
#}
