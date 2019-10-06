output "vnet" {
  value = {
      id            = azurerm_virtual_network.vnet.id
      name          = azurerm_virtual_network.vnet.name
      address_space = azurerm_virtual_network.vnet.address_space
      resource_group_name = azurerm_virtual_network.vnet.resource_group_name
  }
}

