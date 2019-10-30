# Hub Resources
# 1. Resource Groups: Network, Security, Management
# 2. Virtual Network
# 3. Subnets: dmz-subnet, mgt-subnet, fw-subnet, core-subnet

resource "azurerm_resource_group" "rgroup" {
  name = var.resource_group.name
  location = var.resource_group.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network.name
  resource_group_name = azurerm_resource_group.rgroup.name
  location            = azurerm_resource_group.rgroup.location
  address_space       = var.virtual_network.address_space
}

resource "azurerm_subnet" "subnets" {
  count                     = length(var.subnets)
  name                      = element(keys(var.subnets), count.index)
  virtual_network_name      = azurerm_virtual_network.vnet.name
  resource_group_name       = azurerm_resource_group.rgroup.name
  address_prefix            = element(values(var.subnets), count.index)
  #network_security_group_id = lookup keys in subnet_for_nsg, if match then assign value
  network_security_group_id = lookup(var.subnet_nsg, element(keys(var.subnets), count.index),"")
}


# resource "azurerm_subnet" "subnets" {
#   for_each = var.subnets
#     name                      = each.key
#     virtual_network_name      = azurerm_virtual_network.vnet.name
#     resource_group_name       = azurerm_resource_group.rgroup.name
#     address_prefix            = each.value
#     #network_security_group_id = lookup keys in subnet_for_nsg, if match then assign value
#     #network_security_group_id = lookup(var.subnet_nsg, element(keys(var.subnets), each.key),"")
# }
