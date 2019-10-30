output "resource_group" {
  value = {
    name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
  }
}

output "name" {
  value = azurerm_resource_group.rg.name
}

output "location" {
  value = azurerm_resource_group.rg.location
}


# output "resource_group" {
#   value = zipmap(azurerm_resource_group.rg.*.name, azurerm_resource_group.rg.*.location)
# }