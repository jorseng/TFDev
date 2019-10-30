resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network.name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  address_space       = var.virtual_network.address_space
}
