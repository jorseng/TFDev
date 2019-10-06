
resource "azurerm_resource_group" "udr-rg" {
  name = "udr-rg"
  location = "southeastasia"
}

resource "azurerm_virtual_network" "udr-vnet" {
  name = "udr-vnet"
  resource_group_name = azurerm_resource_group.udr-rg.name
  location = azurerm_resource_group.udr-rg.location
  address_space = ["10.5.0.0/16"]
}

resource "azurerm_subnet" "udr-subnet1" {
  name = "udr-subnet1"
  resource_group_name = azurerm_resource_group.udr-rg.name
  virtual_network_name = azurerm_virtual_network.udr-vnet.name
  address_prefix = "10.5.1.0/24"
}

resource "azurerm_subnet" "udr-subnet2" {
  name = "udr-subnet2"
  resource_group_name = azurerm_resource_group.udr-rg.name
  virtual_network_name = azurerm_virtual_network.udr-vnet.name
  address_prefix = "10.5.2.0/24"
}

module "udr-table" {
  source  = "../module_test/udr"
  route_table_name = var.route_table_name
  resource_group = azurerm_resource_group.udr-rg
  routes = var.routes
  subnet_id_list = [azurerm_subnet.udr-subnet2.id]
}

variable "route_table_name" {
  default     = "udr-test-table"
}

variable "routes" {
  default     = {
      "route1" = ["10.5.2.0/24","VnetLocal"]
  }
}
