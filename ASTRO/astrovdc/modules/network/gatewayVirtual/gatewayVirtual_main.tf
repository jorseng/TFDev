resource "azurerm_public_ip" "gwpip" {
  name                = var.gw_pip.name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  allocation_method   = var.gw_pip.allocation_method 
}

resource "azurerm_virtual_network_gateway" "gatewayVirtual" {
  name                = var.gatewayVirtual.name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  type     = var.gatewayVirtual.type
  vpn_type = var.gatewayVirtual.vpn_type

  active_active = false
  enable_bgp    = false
  sku           = var.gatewayVirtual.sku

  ip_configuration {
    name                          = var.gw_pip.name
    public_ip_address_id          = azurerm_public_ip.gwpip.id
    private_ip_address_allocation = var.gw_pip.allocation_method
    subnet_id                     = var.gw_subnet_id
  }
}
