resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network.name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  address_space       = var.virtual_network.address_space
}

resource "azurerm_subnet" "subnets" {
  count                = length(var.subnets)
  name                 = element(keys(var.subnets), count.index)
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group.name
  address_prefix       = element(values(var.subnets), count.index)
}