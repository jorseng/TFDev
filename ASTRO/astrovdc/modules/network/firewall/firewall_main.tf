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
  }
}

