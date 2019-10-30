resource "azurerm_resource_group" "rg" {
  name = var.resource_group.name
  location = var.resource_group.location
}

# resource "azurerm_resource_group" "rg" {
#   count = var.resource_group.count
#   name = "${var.resource_group.name}-${count.index}"
#   location = var.resource_group.location
# }
