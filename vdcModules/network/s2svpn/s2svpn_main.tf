resource "azurerm_public_ip" "gwpip" {
  name                = var.gw_pip.name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  allocation_method   = var.gw_pip.allocation_method 
}

resource "azurerm_virtual_network_gateway" "gateway_virtual" {
  name                = var.gateway_virtual.name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  type     = var.gateway_virtual.type
  vpn_type = var.gateway_virtual.vpn_type

  active_active = var.gateway_virtual.active_active
  enable_bgp    = var.gateway_virtual.enable_bgp
  sku           = var.gateway_virtual.sku

  ip_configuration {
    name                          = "${var.gw_pip.name}-Config"
    public_ip_address_id          = azurerm_public_ip.gwpip.id
    private_ip_address_allocation = var.gateway_virtual.private_ip_allocation_method
    subnet_id                     = var.gw_subnet_id
  }
}

resource "azurerm_local_network_gateway" "gateway_local" {
  name                = var.gateway_local.name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  gateway_address     = var.gateway_local.gateway_address
  address_space       = [var.gateway_local.address_space]
}


resource "azurerm_virtual_network_gateway_connection" "s2s_connection" {
  name                = var.s2s_connection.name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  type                       = var.s2s_connection.type
  virtual_network_gateway_id = azurerm_virtual_network_gateway.gateway_virtual.id
  local_network_gateway_id   = azurerm_local_network_gateway.gateway_local.id

  shared_key = var.s2s_connection.shared_key
}