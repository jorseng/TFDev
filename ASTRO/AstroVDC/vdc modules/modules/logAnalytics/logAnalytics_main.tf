resource "azurerm_resource_group" "rg" {
  name = var.resource_group.name
  location = var.resource_group.location
}

resource "azurerm_log_analytics_workspace" "logAnalytics" {
  name                = var.log_analytics.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.log_analytics.sku
}