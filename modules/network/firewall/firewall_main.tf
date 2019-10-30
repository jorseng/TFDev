resource "azurerm_public_ip" "fw_pip" {
  name                = var.fw_pip.name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  allocation_method   = var.fw_pip.allocation_method
  sku                 = var.fw_pip.sku
}

resource "azurerm_firewall" "firewall" {
  name                = var.firewall_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  ip_configuration {
    name                 = "${azurerm_public_ip.fw_pip.name}-Config"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.fw_pip.id
    # ip should be multiple as well.
  }
}

# NAT Rule
resource "azurerm_firewall_nat_rule_collection" "NATRuleSet" {
  count               = length(var.nat_rule_collection)
  name                = element(keys(var.nat_rule_collection), count.index)
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = var.resource_group.name
  priority            = element(values(var.nat_rule_collection)[count.index], 0)
  action              = element(values(var.nat_rule_collection)[count.index], 1)

  dynamic "rule" {
    for_each = element(values(var.nat_rule_collection)[count.index], 2)
    content {
      name                  = rule.key
      source_addresses      = rule.value[0]
      destination_ports     = rule.value[1]
      destination_addresses = rule.value[2]
      protocols             = rule.value[3]
      translated_address    = rule.value[4]
      translated_port       = rule.value[5]
    }
  }
}

# Network Rule
resource "azurerm_firewall_network_rule_collection" "NetworkRuleSet" {
  count               = length(var.network_rule_collection)
  name                = element(keys(var.network_rule_collection), count.index)
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = var.resource_group.name
  priority            = element(values(var.network_rule_collection)[count.index], 0)
  action              = element(values(var.network_rule_collection)[count.index], 1)

  dynamic "rule" {
    for_each = element(values(var.network_rule_collection)[count.index], 2)
    content {
      name                  = rule.key
      source_addresses      = rule.value[0]
      destination_ports     = rule.value[1]
      destination_addresses = rule.value[2]
      protocols             = rule.value[3]
    }
  }
}


# Application Rule
resource "azurerm_firewall_application_rule_collection" "AppRuleSet" {
  count               = length(var.app_rule_collection)
  name                = element(keys(var.app_rule_collection), count.index)
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = var.resource_group.name
  priority            = element(values(var.app_rule_collection)[count.index], 0)
  action              = element(values(var.app_rule_collection)[count.index], 1)

  dynamic "rule" {
    for_each = element(values(var.app_rule_collection)[count.index], 2)
    content {
      name             = rule.key
      source_addresses = rule.value[0]
      target_fqdns     = rule.value[1]
    }
  }
}


