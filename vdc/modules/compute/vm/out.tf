output "vm" {
  value = {
      id = azurerm_virtual_machine.vm.id
      name = azurerm_virtual_machine.vm.name
  }
}
