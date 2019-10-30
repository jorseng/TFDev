resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
}

resource "azurerm_network_security_rule" "nsgRuleSet" {
  count                       = length(var.nsg_rule_set)
  name                        = element(keys(var.nsg_rule_set), count.index)
  priority                    = element(values(var.nsg_rule_set)[count.index], 0)
  direction                   = element(values(var.nsg_rule_set)[count.index], 1)
  access                      = element(values(var.nsg_rule_set)[count.index], 2)
  protocol                    = element(values(var.nsg_rule_set)[count.index], 3)
  source_port_range           = element(values(var.nsg_rule_set)[count.index], 4)
  destination_port_range      = element(values(var.nsg_rule_set)[count.index], 5)
  source_address_prefix       = element(values(var.nsg_rule_set)[count.index], 6)
  destination_address_prefix  = element(values(var.nsg_rule_set)[count.index], 7)
  resource_group_name         = var.resource_group.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_subnet_network_security_group_association" "nsgAssociation" {
  count                     = length (var.subnet_id_list)
  subnet_id                 = var.subnet_id_list[count.index]
  network_security_group_id = azurerm_network_security_group.nsg.id
}

