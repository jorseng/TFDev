resource "azurerm_subnet" "subnet" {
  name                 = var.subnet.name
  resource_group_name  = var.resource_group.name
  virtual_network_name = var.virtual_network.name
  address_prefix       = var.subnet.address_prefix
}
