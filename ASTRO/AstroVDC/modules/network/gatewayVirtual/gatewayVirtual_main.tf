resource "azurerm_public_ip" "gwpip" {
  name                = var.gw_pip.name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  allocation_method   = var.gw_pip.allocation_method 
  sku                 = var.gw_pip.sku
}

resource "azurerm_virtual_network_gateway" "gatewayVirtual" {
  name                = var.gateway_virtual.name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  type     = var.gateway_virtual.type
  vpn_type = var.gateway_virtual.vpn_type

  active_active = false
  enable_bgp    = false
  sku           = var.gateway_virtual.sku

  ip_configuration {
    name                          = "${var.gw_pip.name}-Config"
    public_ip_address_id          = azurerm_public_ip.gwpip.id
    private_ip_address_allocation = var.gateway_virtual.private_ip_allocation_method
    subnet_id                     = var.gw_subnet_id
  }
}

