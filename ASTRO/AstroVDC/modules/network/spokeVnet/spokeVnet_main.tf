provider "azurerm" {
  alias = "remote"
}

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
  name                         = var.spoke_vnet_peering.name
  resource_group_name          = var.resource_group.name
  virtual_network_name         = azurerm_virtual_network.vnet.name
  remote_virtual_network_id    = var.hub_vnet.id
  allow_virtual_network_access = var.spoke_vnet_peering.allow_virtual_network_access
  allow_forwarded_traffic      = var.spoke_vnet_peering.allow_forwarded_traffic
  allow_gateway_transit       = var.spoke_vnet_peering.allow_gateway_transit
  use_remote_gateways          = var.spoke_vnet_peering.use_remote_gateways
}

resource "azurerm_virtual_network_peering" "peering2" {
  name                         = var.hub_vnet_peering.name
  resource_group_name          = var.hub_vnet.resource_group_name
  virtual_network_name         = var.hub_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet.id
  provider                     = "azurerm.remote"
  allow_virtual_network_access = var.hub_vnet_peering.allow_virtual_network_access
  allow_forwarded_traffic      = var.hub_vnet_peering.allow_forwarded_traffic
  allow_gateway_transit        = var.hub_vnet_peering.allow_gateway_transit
  use_remote_gateways          = var.hub_vnet_peering.use_remote_gateways
}
