resource "azurerm_resource_group" "nsg-rg" {
  name = "nsg-test-rg"
  location = "southeastasia"
}

resource "azurerm_virtual_network" "vnet" {
  name = "nsg-vnet"
  resource_group_name = azurerm_resource_group.nsg-rg.name
  location            = azurerm_resource_group.nsg-rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet1" {
  name = "nsg-subnet"
  resource_group_name = azurerm_resource_group.nsg-rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix = "10.0.1.0/24"
}

# resource "azurerm_network_security_group" "nsg" {
#   name = "nsg-set1"
#   location = azurerm_resource_group.nsg-rg.location
#   resource_group_name = azurerm_resource_group.nsg-rg.name
# }

# resource "azurerm_network_security_rule" "nsgRule" {
#   count                       = length(var.nsgRuleSet)
#   name                        = element(keys(var.nsgRuleSet), count.index)
#   priority                    = element(values(var.nsgRuleSet)[count.index], 0)
#   direction                   = element(values(var.nsgRuleSet)[count.index], 1)
#   access                      = element(values(var.nsgRuleSet)[count.index], 2)
#   protocol                    = element(values(var.nsgRuleSet)[count.index], 3)
#   source_port_range           = element(values(var.nsgRuleSet)[count.index], 4)
#   destination_port_range      = element(values(var.nsgRuleSet)[count.index], 5)
#   source_address_prefix       = element(values(var.nsgRuleSet)[count.index], 6)
#   destination_address_prefix  = element(values(var.nsgRuleSet)[count.index], 7)
#   resource_group_name         = azurerm_resource_group.nsg-rg.name
#   network_security_group_name = azurerm_network_security_group.nsg.name
# }

# resource "azurerm_network_security_rule" "nsgRule1" {
#   name                        = "testrule"
#   priority                    = 1000
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "TCP"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.nsg-rg.name
#   network_security_group_name = azurerm_network_security_group.nsg.name
# }

# resource "azurerm_network_security_rule" "nsgRule2" {
#   name                        = "testrule"
#   priority                    = 1001
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "TCP"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.nsg-rg.name
#   network_security_group_name = azurerm_network_security_group.nsg.name
# }

# resource "azurerm_network_security_rule" "nsgRule" {
#   count                       = length(var.nsgSet.name)
#   name                        = var.nsgSet.name[count.index]
#   priority                    = var.nsgSet.priority[count.index]
#   direction                   = var.nsgSet.direction[count.index]
#   access                      = var.nsgSet.access[count.index]
#   protocol                    = var.nsgSet.protocol[count.index]
#   source_port_range           = var.nsgSet.source_port_range[count.index]
#   destination_port_range      = var.nsgSet.destination_port_range[count.index]
#   source_address_prefix       = var.nsgSet.source_address_prefix[count.index]
#   destination_address_prefix  = var.nsgSet.destination_address_prefix[count.index]
#   resource_group_name         = azurerm_resource_group.nsg-rg.name
#   network_security_group_name = azurerm_network_security_group.nsg.name
# }


# resource "azurerm_subnet_network_security_group_association" "nsgAssociation" {
#   subnet_id                 = azurerm_subnet.subnet1.id
#   network_security_group_id = azurerm_network_security_group.nsg.id
# }