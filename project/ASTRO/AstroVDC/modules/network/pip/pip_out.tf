output "pip" {
  value = {
      id            = azurerm_public_ip.pip.id
      name          = azurerm_public_ip.pip.name
      allocation_method = azurerm_public_ip.pip.allocation_method
  }
}
