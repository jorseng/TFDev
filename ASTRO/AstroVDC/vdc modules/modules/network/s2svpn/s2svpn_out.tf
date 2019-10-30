output "gateway_virtual" {
  value = {
      id = azurerm_virtual_network_gateway.gateway_virtual.id
      name = azurerm_virtual_network_gateway.gateway_virtual.name
      type = azurerm_virtual_network_gateway.gateway_virtual.type
      vpn_type = azurerm_virtual_network_gateway.gateway_virtual.vpn_type
      sku = azurerm_virtual_network_gateway.gateway_virtual.sku
      location = azurerm_virtual_network_gateway.gateway_virtual.location
  }
}

output "gateway_local" {
  value = {
      id = azurerm_local_network_gateway.gateway_local.id
      name = azurerm_local_network_gateway.gateway_local.name
      location = azurerm_local_network_gateway.gateway_local.location
      gateway_address = azurerm_local_network_gateway.gateway_local.gateway_address
      address_space = azurerm_local_network_gateway.gateway_local.address_space
  }
}

output "gateway_pip" {
  value       = {
    id = azurerm_public_ip.gwpip.id
    name = azurerm_public_ip.gwpip.name

  }
}
