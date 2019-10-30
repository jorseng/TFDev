output "express_route" {
  value = {
      id = azurerm_express_route_circuit.express_route.id
      name = azurerm_express_route_circuit.express_route.name
  }
}
