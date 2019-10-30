# Route Table
resource "azurerm_route_table" "routeTable" {
  name                = var.route_table_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
}

# Routes
resource "azurerm_route" "routes" {
  count               = length(var.routes)
  name                = element(keys(var.routes), count.index)
  resource_group_name = var.resource_group.name
  route_table_name    = azurerm_route_table.routeTable.name
  address_prefix      = element(values(var.routes)[count.index], 0)
  next_hop_type       = element(values(var.routes)[count.index], 1)
}

# Associate Route Table to Subnets
resource "azurerm_subnet_route_table_association" "routeTableAssociation" {
  count          = length(var.subnet_id_list)
  subnet_id      = element(var.subnet_id_list, count.index)
  route_table_id = azurerm_route_table.routeTable.id
}
