resource "azurerm_express_route_circuit" "express_route" {
  name                  = var.express_route.name
  resource_group_name   = var.resource_group.name
  location              = var.resource_group.location
  service_provider_name = var.express_route.service_provider_name
  peering_location      = var.express_route.peering_location
  bandwidth_in_mbps     = var.express_route.bandwidth_in_mbps

  sku {
    tier   = var.express_route.sku_tier
    family = var.express_route.sku_family
  }
}


