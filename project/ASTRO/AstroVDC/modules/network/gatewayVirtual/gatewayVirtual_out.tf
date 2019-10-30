output "gateway_virtual" {
  value = {
      id = azurerm_virtual_network_gateway.gatewayVirtual.id
      name = azurerm_virtual_network_gateway.gatewayVirtual.name
      location = azurerm_virtual_network_gateway.gatewayVirtual.location
  }
}
