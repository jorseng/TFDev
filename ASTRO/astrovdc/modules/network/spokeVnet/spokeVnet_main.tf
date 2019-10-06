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

resource "azurerm_virtual_network_peering" "peering1" {
  name = var.local_vnet_peering_name
  resource_group_name = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = var.remote_vnet.id
}

resource "azurerm_virtual_network_peering" "peering2" {
  name = var.remote_vnet_peering_name
  resource_group_name = var.remote_vnet.resource_group_name
  virtual_network_name = var.remote_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
}
