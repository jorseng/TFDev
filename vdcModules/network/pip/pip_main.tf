resource "azurerm_public_ip" "pip" {
  name = var.pip.name
  location = var.resource_group.location
  resource_group_name = var.resource_group.name
  allocation_method = var.pip.allocation_method
}
